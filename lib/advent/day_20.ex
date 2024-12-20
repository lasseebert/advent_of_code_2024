defmodule Advent.Day20 do
  @moduledoc """
  Day 20
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t(), integer) :: integer
  def part_1(input, min_save) do
    {walls, start, goal} = input |> parse()

    distances = walk(%{start => 0}, walls, start, goal)

    distances
    |> Enum.flat_map(fn {pos, distance} ->
      pos
      |> second_neighbours()
      |> Enum.flat_map(fn second_neighbour ->
        if Map.has_key?(distances, second_neighbour) and
             distances[second_neighbour] > distance + 2 do
          [distances[second_neighbour] - distance - 2]
        else
          []
        end
      end)
    end)
    |> Enum.count(fn saving -> saving >= min_save end)
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

  defp second_neighbours({x, y}) do
    [
      {x, y - 2},
      {x, y + 2},
      {x - 2, y},
      {x + 2, y}
    ]
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
