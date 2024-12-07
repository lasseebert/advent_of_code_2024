defmodule Advent.Day07 do
  @moduledoc """
  Day 07
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.filter(&valid_1?/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp valid_1?({result, [first | values]}) do
    possible_1?(result, first, values)
  end

  defp possible_1?(result, acc, _) when acc > result, do: false
  defp possible_1?(result, acc, []) when acc != result, do: false
  defp possible_1?(result, acc, []) when acc == result, do: true

  defp possible_1?(result, acc, [value | values]) do
    possible_1?(result, acc + value, values) || possible_1?(result, acc * value, values)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.filter(&valid_2?/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp valid_2?({result, [first | values]}) do
    possible_2?(result, first, values)
  end

  defp possible_2?(result, acc, _) when acc > result, do: false
  defp possible_2?(result, acc, []) when acc != result, do: false
  defp possible_2?(result, acc, []) when acc == result, do: true

  defp possible_2?(result, acc, [value | values]) do
    possible_2?(result, acc + value, values) || possible_2?(result, acc * value, values) ||
      possible_2?(result, concat(acc, value), values)
  end

  defp concat(acc, value) do
    [acc, value] |> Enum.map(&Integer.to_string/1) |> Enum.join() |> String.to_integer()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(": ", trim: true)
    |> then(fn [result, values] ->
      {
        String.to_integer(result),
        values |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      }
    end)
  end
end
