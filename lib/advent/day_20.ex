defmodule Advent.Day20 do
  @moduledoc """
  Day 20
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t(), integer) :: integer
  def part_1(input, min_save) do
    solve(input, min_save, 2)
  end

  @doc """
  Part 2

  Algorithm:

  * Build a map of distances from the start to each position
  * For each position, count number of good cheats:
    * For each other position within max_cheat manahattan distance:
      * If going directlt to the other posistions saves at least min-save steps, count it

  Runs in around 900ms on my machine
  """
  @spec part_2(String.t(), integer) :: integer
  def part_2(input, min_save) do
    solve(input, min_save, 20)
  end

  defp solve(input, min_save, max_cheat) do
    {walls, start, goal} = input |> parse()

    distances = walk(%{start => 0}, walls, start, goal)

    distances
    |> Enum.reduce(0, fn {pos, distance}, count ->
      d_count =
        pos
        |> within_manhattan(max_cheat)
        |> Enum.count(fn second_neighbour ->
          dist = manhattan(pos, second_neighbour)

          Map.has_key?(distances, second_neighbour) and
            distances[second_neighbour] >= distance + dist + min_save
        end)

      count + d_count
    end)
  end

  defp manhattan({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp within_manhattan({x, y}, distance) do
    for dx <- -distance..distance,
        dy <- -distance..distance,
        abs(dx) + abs(dy) <= distance do
      {x + dx, y + dy}
    end
  end

  defp walk(distances, _walls, current, goal) when current == goal, do: distances

  defp walk(distances, walls, current, goal) do
    current
    |> neighbours(walls)
    |> Enum.reject(&Map.has_key?(distances, &1))
    |> case do
      [next] -> walk(Map.put(distances, next, distances[current] + 1), walls, next, goal)
    end
  end

  defp neighbours({x, y}, walls) do
    [
      {x, y - 1},
      {x, y + 1},
      {x - 1, y},
      {x + 1, y}
    ]
    |> Enum.reject(&MapSet.member?(walls, &1))
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({MapSet.new(), nil, nil}, fn {line, y}, acc ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, {walls, start, goal} = acc ->
        case char do
          "S" -> {walls, {x, y}, goal}
          "E" -> {walls, start, {x, y}}
          "#" -> {MapSet.put(walls, {x, y}), start, goal}
          "." -> acc
        end
      end)
    end)
  end
end
