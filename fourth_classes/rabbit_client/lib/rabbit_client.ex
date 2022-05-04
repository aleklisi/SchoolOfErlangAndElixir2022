defmodule RabbitClient do
  @guesses_queue_name "guesses_queue"
  @word_of_the_day_exchange_name "word_of_the_day"
  def setup do
    {:ok, connection} = AMQP.Connection.open(options())
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Queue.declare(channel, @guesses_queue_name)
    AMQP.Exchange.declare(channel, @word_of_the_day_exchange_name, :fanout)

    AMQP.Connection.close(connection)
  end

  def change_word_of_the_day(new_word) do
    {:ok, connection} = AMQP.Connection.open(options())
    {:ok, channel} = AMQP.Channel.open(connection)
    message = Jason.encode!(%{:type => :word_of_the_day, :new_word => new_word})

    AMQP.Basic.publish(channel, @word_of_the_day_exchange_name, "", message)
    AMQP.Connection.close(connection)
  end

  def client(guess_word) do
    {:ok, connection} = AMQP.Connection.open(options())
    {:ok, channel} = AMQP.Channel.open(connection)

    {:ok, %{:queue => reply_queue_name}} = AMQP.Queue.declare(channel)
    AMQP.Basic.consume(channel, reply_queue_name, nil, no_ack: true)

    message =
      Jason.encode!(%{
        :type => :guess,
        :guess_word => guess_word,
        :reply_queue_name => reply_queue_name
      })

    AMQP.Basic.publish(channel, "", @guesses_queue_name, message)

    receive do
      {:basic_deliver, payload, _meta} ->
        IO.puts(" Client received #{payload}")
      after
        5_000 -> :timeout
    end

    AMQP.Connection.close(connection)
  end

  def checker() do
    {:ok, connection} = AMQP.Connection.open(options())
    {:ok, channel} = AMQP.Channel.open(connection)

    {:ok, %{:queue => word_of_the_day_queue_name}} = AMQP.Queue.declare(channel)
    AMQP.Queue.bind(channel, word_of_the_day_queue_name, @word_of_the_day_exchange_name)
    AMQP.Basic.consume(channel, word_of_the_day_queue_name, nil, no_ack: true)

    AMQP.Basic.consume(channel, @guesses_queue_name, nil, no_ack: true)

    checker_loop(channel, {:error, "Now word of the day was given yet"})
  end

  defp checker_loop(channel, old_word) do
    receive do
      {:basic_deliver, payload, _meta} ->
        case Jason.decode!(payload) do
          %{"type" => "word_of_the_day", "new_word" => new_word} ->
            checker_loop(channel, new_word)

          %{"type" => "guess", "guess_word" => guess_word, "reply_queue_name" => reply_queue_name} ->
            check_and_reply(channel, reply_queue_name, old_word, guess_word)
            checker_loop(channel, old_word)
        end
    end
  end

  defp check_and_reply(channel, reply_queue_name, old_word, guess_word) do
    # TODO implemnt actuall checking
    IO.inspect(guess_word, label: "checker got a word ")
    reply_message =
      Jason.encode!(%{:type => :reply, :old_word => old_word, :guess_word => guess_word})

    AMQP.Basic.publish(channel, "", reply_queue_name, reply_message)
  end

  defp options do
    [
      host: "localhost",
      port: 5672,
      username: "test",
      password: "test"
    ]
  end
end
