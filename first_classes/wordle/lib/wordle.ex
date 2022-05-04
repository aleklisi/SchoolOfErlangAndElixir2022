defmodule Wordle do
  
  def color_word(actual, guess) do
    [actual, guess] = Enum.map([actual, guess], &letter_position_map/1)

    Enum.reduce(guess, %{}, fn {letter, pos}, acc ->
      case actual[letter] do
        nil -> mark_gray(pos, acc)
        actual_pos -> check_positions(actual_pos, pos, acc)
      end
    end)
    |> Map.values()
  end

  def check_positions(actual, guess, acc) when length(guess) <= length(actual) do
    Enum.reduce(guess, acc, fn pos, acc -> 
      case pos in actual do
        true -> Map.put(acc, pos, :green)
        false -> Map.put(acc, pos, :yellow)
      end
    end)
  end

  def check_positions(actual, guess, acc) when length(guess) > length(actual) do
    {hits, misses} = Enum.split(guess, length(guess) - length(actual))
    acc = check_positions(actual, hits, acc)
    mark_gray(misses, acc)
  end

  def mark_gray(idx, acc) do
    for i <- idx, into: acc, do: {i, :gray}
  end

  def letter_position_map(word) do
    word
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {char, idx}, acc ->
      {_, acc} =
        Map.get_and_update(acc, char, fn current ->
          case current do
            nil -> {current, [idx]}
            val -> {val, val ++ [idx]}
          end
        end)

      acc
    end)
  end

end
