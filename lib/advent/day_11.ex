defmodule Advent.Day11 do
  @moduledoc """
  Day 11
  """

  @doc """
  Part 1

  Algorithm: Depth-first search with memoization using {stone, n} as keys where
  n is the number of blinks left.

  Part 2 takes around 120 ms on my machine using a memoization map of size ~130k.
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    solve(input, 25)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    solve(input, 75)
  end

  def solve(input, count) do
    stones = parse(input)

    # Recursively build a map of {stone, n} -> final_count
    map =
      stones
      |> Enum.reduce(%{}, fn stone, map ->
        build_map(map, stone, count)
      end)

    # The map must include the starting stones, so now we use it to sum up.
    stones
    |> Enum.reduce(0, fn stone, acc -> acc + Map.fetch!(map, {stone, count}) end)
  end

  # With zero blinks left, the stone is just one stone
  defp build_map(map, stone, 0), do: Map.put(map, {stone, 0}, 1)

  defp build_map(map, stone, n) do
    if Map.has_key?(map, {stone, n}) do
      # Utilize memoization
      map
    else
      # Blink one time
      next_stones = blink(stone)

      # Recursively build the map
      map =
        Enum.reduce(next_stones, map, fn next_stone, map ->
          build_map(map, next_stone, n - 1)
        end)

      # Now that the submap is built, we can sum up the results and update the memoization map
      result = next_stones |> Enum.reduce(0, fn next_stone, acc -> acc + Map.fetch!(map, {next_stone, n - 1}) end)
      Map.put(map, {stone, n}, result)
    end
  end

  defp blink(0), do: [1]

  defp blink(stone) do
    str = Integer.to_string(stone)
    str_length = String.length(str)

    if rem(str_length, 2) == 0 do
      str
      |> String.split_at(div(str_length, 2))
      |> Tuple.to_list()
      |> Enum.map(&String.to_integer/1)
    else
      [stone * 2024]
    end
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
