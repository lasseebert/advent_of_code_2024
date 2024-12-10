defmodule Advent.Day10 do
  @moduledoc """
  Day 10
  """

  @doc """
  Part 1

  Algorithm:

  * Find all 0's and put them in a set (the worklist)
  * For each integer up to 9, find adjacent grid points that can be reached from the worklist,
    and add them to the worklist of the next round.
  * Each entry in the worklist contains {pos, origin}, where origin is the pos of the original 0.
  * Count worklist size after round 9.
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    solve(input, & &1, fn origin, _ -> origin end)
  end

  @doc """
  Part 2

  Same algorithm as part 1, but each worklist item is {pos, trail}
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    solve(input, &[&1], &[&1 | &2])
  end

  defp solve(input, create_item, update_item) do
    map = input |> parse()

    # Make initial worklist from all 0 places
    worklist =
      Enum.reduce(map, MapSet.new(), fn {pos, value}, worklist ->
        if value == 0 do
          MapSet.put(worklist, {pos, create_item.(pos)})
        else
          worklist
        end
      end)

    count_trails(worklist, map, 1, update_item)
  end

  defp count_trails(worklist, _map, 10, _update), do: MapSet.size(worklist)

  defp count_trails(worklist, map, height, update_item) do
    worklist
    |> Enum.reduce(MapSet.new(), fn {pos, item}, new_worklist ->
      pos
      |> neighbours()
      |> Enum.reduce(new_worklist, fn neighbour, new_worklist ->
        if Map.get(map, neighbour) == height do
          MapSet.put(new_worklist, {neighbour, update_item.(item, neighbour)})
        else
          new_worklist
        end
      end)
    end)
    |> count_trails(map, height + 1, update_item)
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
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, map ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {char, x}, map ->
        Map.put(map, {x, y}, String.to_integer(char))
      end)
    end)
  end
end
