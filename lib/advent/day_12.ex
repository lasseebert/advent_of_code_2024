defmodule Advent.Day12 do
  @moduledoc """
  Day 12
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(fn region -> area(region) * perimeter(region) end)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.map(fn region -> area(region) * sides(region) end)
    |> Enum.sum()
  end

  defp area(region), do: MapSet.size(region)

  defp perimeter(region) do
    Enum.reduce(region, 0, fn pos, acc ->
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
  end

  defp sides(region) do
    num_vertical_sides =
      region
      |> Enum.flat_map(fn {x, y} ->
        west = {x - 1, y}
        east = {x + 1, y}

        # It seems that western and eastern fences that form a straight line
        # can't be seen as a single side of the fence, so we need to include the
        # dir in the position.
        #
        # This can happen eg here
        #
        #  XXXX  <- This easter side
        #  X   X <- This western side
        #  XXXXX
        [
          if(!MapSet.member?(region, west), do: {:west, {x, y}}),
          if(!MapSet.member?(region, east), do: {:east, {x, y}})
        ]
        |> Enum.reject(&is_nil/1)
      end)
      |> Enum.sort()
      |> Enum.reduce([], fn
        # When the next segment is in line with the previous we only keep the next
        {dir, {x, y1}}, [{dir, {x, y2}} | sides] when y1 == y2 + 1 -> [{dir, {x, y1}} | sides]
        pos, sides -> [pos | sides]
      end)
      |> length()

    # I don't have a proof, but I think the horizontal lines always equals the vertical lines.
    num_vertical_sides * 2
  end

  defp neighbours({x, y}) do
    [
      {x, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x, y + 1}
    ]
  end

  defp parse(input) do
    input
    |> parse_map()
    |> find_regions()
  end

  defp find_regions(map) do
    # A set of all unprocessed positions
    worklist = map |> Map.keys() |> MapSet.new()

    find_regions(worklist, [], map)
  end

  defp find_regions(worklist, acc, map) do
    if MapSet.size(worklist) == 0 do
      acc
    else
      # TODO: Better way to get a random element from a set?
      pos = worklist |> MapSet.to_list() |> hd()
      region = find_region(pos, map)
      worklist = MapSet.difference(worklist, region)

      find_regions(worklist, [region | acc], map)
    end
  end

  # Gets a connected region of the same plant
  defp find_region(pos, map), do: find_region(Map.fetch!(map, pos), map, MapSet.new([pos]), [pos])

  defp find_region(_plant, _map, region, []), do: region

  defp find_region(plant, map, region, [next_pos | unchecked]) do
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

    find_region(plant, map, region, unchecked)
  end

  defp parse_map(input) do
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
