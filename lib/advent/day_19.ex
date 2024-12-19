defmodule Advent.Day19 do
  @moduledoc """
  Day 19
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {towels, patterns} = input |> parse()

    Enum.count(patterns, &valid?(&1, towels))
  end

  defp valid?([], _towels), do: true

  defp valid?(pattern, towels) do
    towels
    |> Enum.filter(&prefix?(&1, pattern))
    |> Enum.any?(fn towel ->
      pattern
      |> Enum.drop(length(towel))
      |> valid?(towels)
    end)
  end

  defp prefix?([], _pattern), do: true
  defp prefix?([a | towel], [a | pattern]), do: prefix?(towel, pattern)
  defp prefix?(_towel, _pattern), do: false

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
    |> String.split("\n\n", trim: true)
    |> then(fn [towels, patterns] ->
      {
        parse_towels(towels),
        parse_patterns(patterns)
      }
    end)
  end

  defp parse_towels(input) do
    input
    |> String.split(", ", trim: true)
    |> Enum.map(&parse_towel/1)
  end

  defp parse_patterns(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_towel/1)
  end

  defp parse_towel(string) do
    string
    |> String.graphemes()
    |> Enum.map(fn
      "w" -> :white
      "u" -> :blue
      "b" -> :black
      "r" -> :red
      "g" -> :green
    end)
  end
end
