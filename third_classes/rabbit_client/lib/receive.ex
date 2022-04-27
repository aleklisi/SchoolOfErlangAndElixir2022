defmodule Receive do
    def wait_for_messages(channel_name, n) do
        {:ok, connection} = AMQP.Connection.open(options())
        {:ok, channel} = AMQP.Channel.open(connection)
        AMQP.Queue.declare(channel, channel_name)
        AMQP.Basic.consume(channel, channel_name, nil, no_ack: true)
        wait_for_messages(n)
    end

    defp wait_for_messages(0), do: :ok
    defp wait_for_messages(n) do
    receive do
        {:basic_deliver, payload, _meta} ->
            IO.puts " [x] Received #{payload}"
            wait_for_messages(n-1)
        end
    end

    def check_word_of_the_day do
        {:ok, connection} = AMQP.Connection.open(options())
        {:ok, channel} = AMQP.Channel.open(connection)
        ##  Whenever we connect to Rabbit we need a fresh, empty queue.
        ##  To do it we could create a queue with a random name, or, even better
        ##  - let the server choose a random queue name for us.
        ##  We can do this by not supplying the queue parameter to `AMQP.Queue.declare`.

        ## There's an exclusive flag, which is reposnsible for deleting the queue 
        ## once the consumer connection is closed
        # https://hexdocs.pm/amqp/AMQP.Queue.html#declare/3
        {:ok, %{queue: my_queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true)

        IO.inspect("My_queue_name is #{my_queue_name}")

        AMQP.Queue.bind(channel, my_queue_name, "word_of_the_day")
        AMQP.Basic.consume(channel, my_queue_name, nil, no_ack: true)
        wait_for_messages(10)
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

