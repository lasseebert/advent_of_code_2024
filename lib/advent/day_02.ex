defmodule Advent.Day02 do
  @moduledoc """
  Day 02
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.count(&is_safe/1)
  end

  defp is_safe(levels) do
    [a, b | _] = levels
    ascending = a < b

    levels
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] ->
      if ascending do
        a < b and b - a <= 3
      else
        a > b and a - b <= 3
      end
    end)
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
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
