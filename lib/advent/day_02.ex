defmodule Advent.Day02 do
  @moduledoc """
  Day 02
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input |> parse() |> count_good(0)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input |> parse() |> count_good(1)
  end

  defp count_good(input, max_errors) do
    Enum.count(input, fn levels ->
      # We call this with both directions, so that we can assume that only
      # ascending order is correct
      safe?(nil, levels, 0, max_errors) or safe?(nil, Enum.reverse(levels), 0, max_errors)
    end)
  end

  # Too many errors
  defp safe?(_last, _levels, errors, max) when errors > max, do: false

  # Reached end of list without too many errors
  defp safe?(_last, [], _errors, _max), do: true

  # Next element matches previous
  defp safe?(last, [a | levels], errors, max) when is_nil(last) or (is_integer(last) and (a - last) in 1..3) do
    # Even when a level matches the previous, it might be needed to take it
    # out, so we try both ways
    safe?(a, levels, errors, max) or safe?(last, levels, errors + 1, max)
  end

  # Next element does not match previous
  defp safe?(last, [_a | levels], errors, max) do
    safe?(last, levels, errors + 1, max)
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
