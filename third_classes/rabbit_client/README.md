# RabbitClient

Run me with `iex -S mix`.

## Exercise

I'd like you to implement a communication between clients and wordle solvers.

### The environment 

In one of the terminals connected to RabbitMQ declare a queue,
this queue is for all of the guesses to come, name it `"guesses"`.
Next create an exchange where the word of the day will be published on daily bases for all of the word checkers, name it `"word_of_the_day"`.

### The word checkers

The word_checkers will consume the messages from `"guesses"` queue and it will create it's own queue (with name generated) and plug it in to the `"word_of_the_day"` exchange.
The word_checkers should consume the message from it's own queue too. 

### The client

The client connects to RabbitMQ (setup connection ad channel as we did in the classes),
declares a queue
(with `{:ok, %{queue: response_queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true)`),
and sends a guess and a response_queue_name to the `"guesses"` queue.

## The workflow

Each of the world_checkers gets a word of the day to its state.
The state can be stored in a recursive function as an argument:
```elixir
def f(state) do
    receive do
        msg -> 
            # do stuff with the message
            new_state = ...
            f(new_state)
    end
end
``` 

A client publishes a message `"guess|reply_queue_name"` to the `"quesses"` queue
and waits for a reply delivered to the `reply_queue_name`.

One of the word_checkers consumes the `"guess|reply_queue_name"`,
checks the word and generates a reply,
sending the reply to the `reply_queue_name` queue.

Regarding the reply I suggest a 5 letters string where each 
    - green letter is passed as letter `g`
    - yellow letter is passed as letter `y`
    - gray(black) letter is passed as letter `b`

A client receives a reply and prints it on a screen.