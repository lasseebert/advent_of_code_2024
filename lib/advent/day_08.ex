defmodule Advent.Day08 do
  @moduledoc """
  Day 08
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {antennas, dimensions} = input |> parse()

    antennas
    |> Map.values()
    |> Enum.reduce(MapSet.new(), fn positions, antinodes ->
      positions
      |> pairs()
      |> Enum.reduce(antinodes, fn {a, b}, antinodes ->
        diff = sub(a, b)
        node_1 = add(a, diff)
        node_2 = sub(b, diff)

        [node_1, node_2]
        |> Enum.filter(&inside_map?(&1, dimensions))
        |> Enum.reduce(antinodes, &MapSet.put(&2, &1))
      end)
    end)
    |> Enum.count()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    {antennas, dimensions} = input |> parse()

    antennas
    |> Map.values()
    |> Enum.reduce(MapSet.new(), fn positions, antinodes ->
      positions
      |> pairs()
      |> Enum.reduce(antinodes, fn {a, b}, antinodes ->
        diff = sub(a, b)

        antinodes
        |> add_nodes(a, diff, dimensions)
        |> add_nodes(b, sub({0, 0}, diff), dimensions)
      end)
    end)
    |> Enum.count()
  end

  defp sub({x1, y1}, {x2, y2}), do: {x1 - x2, y1 - y2}
  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  defp inside_map?({x, y}, {max_x, max_y}), do: x >= 0 and x <= max_x and y >= 0 and y <= max_y

  defp pairs(list) do
    for a <- list, b <- list, a < b, do: {a, b}
  end

  defp add_nodes(antinodes, coord, delta, dimensions) do
    if inside_map?(coord, dimensions) do
      next_coord = add(coord, delta)
      add_nodes(MapSet.put(antinodes, coord), next_coord, delta, dimensions)
    else
      antinodes
    end
  end

  defp parse(input) do
    map =
      input
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, map ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.reduce(map, fn {char, x}, map ->
          case char do
            "." -> Map.put(map, {x, y}, :empty)
            char -> Map.put(map, {x, y}, {:antenna, char})
          end
        end)
      end)

    max_x = map |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_y = map |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    antennas =
      map
      |> Map.filter(&match?({:antenna, _}, elem(&1, 1)))
      |> Enum.map(fn {coord, {:antenna, char}} -> {char, coord} end)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    {antennas, {max_x, max_y}}
  end
end
