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

    MapSet.new()
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

  Note: This runs in around 6 seconds on my machine. Perhaps there is a smarter
  way than to just try putting an obstacle on every single point in the normal
  route?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    {map, guard} = input |> parse()
    {start_pos, _dir} = guard

    candidates = MapSet.new() |> walk(map, guard) |> MapSet.delete(start_pos)
    Enum.count(candidates, &loop?(Map.put(map, &1, :wall), guard))
  end

  defp loop?(map, guard) do
    walk_loop(MapSet.new(), map, guard)
  end

  defp walk_loop(visited, map, {pos, dir} = guard) do
    if MapSet.member?(visited, guard) do
      true
    else
      visited = MapSet.put(visited, guard)

      next_pos = add(pos, dir)

      case Map.get(map, next_pos) do
        :empty -> walk_loop(visited, map, {next_pos, dir})
        :wall -> walk_loop(visited, map, {pos, turn_right(dir)})
        nil -> false
      end
    end
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
