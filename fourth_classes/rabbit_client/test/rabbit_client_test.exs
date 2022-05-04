defmodule RabbitClientTest do
  use ExUnit.Case
  doctest RabbitClient

  test "greets the world" do
    assert RabbitClient.hello() == :world
  end
end
