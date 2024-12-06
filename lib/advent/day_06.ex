defmodule Advent.Day06 do
  @moduledoc """
  Day 06
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {map, guard} = input |> parse()

    visited = MapSet.new()

    visited
    |> walk(map, guard)
    |> Enum.count()
  end

  defp walk(visited, map, {pos, dir}) do
    visited = MapSet.put(visited, pos)

    next_pos = add(pos, dir)

    case Map.get(map, next_pos) do
      :empty -> walk(visited, map, {next_pos, dir})
      :wall -> walk(visited, map, {pos, turn_right(dir)})
      nil -> visited
    end
  end

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  defp turn_right({0, -1}), do: {1, 0}
  defp turn_right({1, 0}), do: {0, 1}
  defp turn_right({0, 1}), do: {-1, 0}
  defp turn_right({-1, 0}), do: {0, -1}

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
    |> Enum.reduce({%{}, nil}, fn {line, y}, {map, guard} ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce({map, guard}, fn {char, x}, {map, guard} ->
        case char do
          "." -> {Map.put(map, {x, y}, :empty), guard}
          "#" -> {Map.put(map, {x, y}, :wall), guard}
          "^" -> {Map.put(map, {x, y}, :empty), {{x, y}, {0, -1}}}
        end
      end)
    end)
  end
end
