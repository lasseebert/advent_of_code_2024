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

    patterns
    |> Enum.reduce({0, %{}}, fn pattern, {count, cache} ->
      {combos, cache} = count_combos(pattern, towels, cache)

      count =
        if combos > 0 do
          count + 1
        else
          count
        end

      {count, cache}
    end)
    |> elem(0)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    {towels, patterns} = input |> parse()

    patterns
    |> Enum.reduce({0, %{}}, fn pattern, {count, cache} ->
      {combos, cache} = count_combos(pattern, towels, cache)
      {count + combos, cache}
    end)
    |> elem(0)
  end

  defp count_combos([], _towels, cache), do: {1, cache}

  defp count_combos(pattern, towels, cache) do
    case Map.fetch(cache, pattern) do
      {:ok, count} ->
        {count, cache}

      :error ->
        towels
        |> Enum.filter(&prefix?(&1, pattern))
        |> Enum.reduce({0, cache}, fn towel, {count, cache} ->
          {d_count, cache} =
            pattern
            |> Enum.drop(length(towel))
            |> count_combos(towels, cache)

          count = count + d_count
          cache = Map.put(cache, pattern, count)
          {count, cache}
        end)
    end
  end

  defp prefix?([], _pattern), do: true
  defp prefix?([a | towel], [a | pattern]), do: prefix?(towel, pattern)
  defp prefix?(_towel, _pattern), do: false

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
