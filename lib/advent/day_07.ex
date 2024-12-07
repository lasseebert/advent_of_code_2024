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
    |> Enum.filter(&valid?/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp valid?({result, [first | values]}) do
    possible?(result, first, values)
  end

  defp possible?(result, acc, _) when acc > result, do: false
  defp possible?(result, acc, []) when acc != result, do: false
  defp possible?(result, acc, []) when acc == result, do: true

  defp possible?(result, acc, [value | values]) do
    possible?(result, acc + value, values) || possible?(result, acc * value, values)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()

    0
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
