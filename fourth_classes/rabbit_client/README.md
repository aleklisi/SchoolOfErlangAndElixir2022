# Rabbit Worlde processing example

## How to run it?

Please open terminals, each with `iex -S mix`.
In the first terminal set up the quesses queue and the word of the day exchange: `RabbitClient.setup`.
In the second and third terminals start checkers: `RabbitClient.checker`.
Back in the first terminal setup a word of the day `RabbitClient.change_word_of_the_day("chair")` and
pass a few words to be checked with `RabbitClient.client("chess")`.

Observe how messages are distributed across checkers in a round-robin fashion.
