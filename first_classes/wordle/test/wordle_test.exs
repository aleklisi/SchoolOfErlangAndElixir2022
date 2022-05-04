defmodule WordleTest do
  use ExUnit.Case, async: false

  test "none of the latters match" do
    expected = 1..5 |> Enum.to_list() |> Enum.map(fn _ -> :gray end)
    assert expected == Wordle.color_word("abcde", "fghij")
  end

  test "all of the latters match" do
    expected = 1..5 |> Enum.to_list() |> Enum.map(fn _ -> :green end)
    assert expected == Wordle.color_word("abcde", "abcde")
  end

  test "a letter is in different place" do
    expected = [:green, :yellow, :gray, :gray, :gray]
    assert expected == Wordle.color_word("short", "solve")
  end

  test "a letter is passed 2 times but exists once in a word both in different place" do
    expected = [:yellow, :gray, :gray, :gray, :gray]
    assert expected == Wordle.color_word("raise", "alamo")
  end

  test "a letter is passed 3 times but exists once in a word both in different place" do
    expected = [:yellow, :yellow, :gray, :green, :gray]
    assert expected == Wordle.color_word("dames", "added")
  end

  test "a letter is passed 2 times but exists once in a word and one is in the right place" do
    expected = [:green, :green, :gray, :gray, :green]
    assert expected == Wordle.color_word("boats", "books")
  end

  test "a letter is passed 3 times but exists once in a word and one is in the right place" do
    expected = [:green, :gray, :gray, :gray, :green]
    assert expected == Wordle.color_word("diddy", "doggy")
  end



end
