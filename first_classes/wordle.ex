defmodule Wordle do
  def color_word(actual, guess) do
    guess
    |> index_string()
    |> check_guess(char_freq_index(actual))
  end

  def char_freq_index(string) do
    string
    |> index_string()
    |> Enum.reduce(%{}, fn {char, idx}, acc ->
      {_, acc} = 
        Map.get_and_update(acc, char, fn current_val ->
          case current_val do
            nil -> {current_val, [idx]}
            _val -> {current_val, [[idx] | current_val]}
          end
        end)
      acc 
    end)
  end

  def index_string(string) do
    string
    |> :binary.bin_to_list()
    |> Enum.with_index()
  end

  def check_guess(guess, actual) do
    Enum.map(guess, fn {char, idx} ->
      case actual[char] do
        nil -> :grey
        index -> 
          case idx in index do
            true -> :green
            false -> :yellow
          end
      end
    end)
  end
end
