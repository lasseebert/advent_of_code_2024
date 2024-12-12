defmodule Advent.Day12 do
  @moduledoc """
  Day 12
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    map = input |> parse()

    # A set of all unprocessed positions
    worklist = map |> Map.keys() |> MapSet.new()

    sum_garden_price(worklist, 0, map)
  end

  defp sum_garden_price(worklist, acc, map) do
    if MapSet.size(worklist) == 0 do
      acc
    else
      # TODO: Better way to get a random element from a set?
      pos = worklist |> MapSet.to_list() |> hd()
      region = get_region(pos, map)

      worklist = MapSet.difference(worklist, region)
      price = garden_price(region)
      sum_garden_price(worklist, acc + price, map)
    end
  end

  defp get_region(pos, map), do: get_region(Map.fetch!(map, pos), map, MapSet.new([pos]), [pos])

  defp get_region(_plant, _map, region, []), do: region

  defp get_region(plant, map, region, [next_pos | unchecked]) do
    {region, unchecked} =
      next_pos
      |> neighbours()
      |> Enum.reduce({region, unchecked}, fn neighbour, {region, unchecked} ->
        if MapSet.member?(region, neighbour) do
          {region, unchecked}
        else
          if Map.get(map, neighbour) == plant do
            {
              MapSet.put(region, neighbour),
              [neighbour | unchecked]
            }
          else
            {region, unchecked}
          end
        end
      end)

    get_region(plant, map, region, unchecked)
  end

  defp garden_price(region) do
    area = MapSet.size(region)

    perimeter =
      region
      |> Enum.reduce(0, fn pos, acc ->
        pos
        |> neighbours()
        |> Enum.reduce(acc, fn neighbour, acc ->
          if MapSet.member?(region, neighbour) do
            acc
          else
            acc + 1
          end
        end)
      end)

    area * perimeter
  end

  defp neighbours({x, y}) do
    [
      {x, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x, y + 1}
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
    |> Enum.reduce(%{}, fn {line, y}, map ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {char, x}, map ->
        Map.put(map, {x, y}, char)
      end)
    end)
  end
end
