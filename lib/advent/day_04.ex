defmodule Advent.Day04 do
  @moduledoc """
  Day 04
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    map = input |> parse()

    max_x = map |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_y = map |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    for x <- 0..max_x, y <- 0..max_y do
      count_xmas(map, {x, y})
    end
    |> Enum.sum()
  end

  defp count_xmas(map, coord) do
    if Map.get(map, coord) == "X" do
      for dx <- -1..1, dy <- -1..1, {dx, dy} != {0, 0} do
        {dx, dy}
      end
      |> Enum.count(&mas?(map, coord, &1))
    else
      0
    end
  end

  defp mas?(map, coord, dir) do
    ["M", "A", "S"]
    |> Enum.reduce_while(coord, fn char, coord ->
      next_coord = add(coord, dir)

      if Map.get(map, next_coord) == char do
        {:cont, next_coord}
      else
        {:halt, :not_found}
      end
    end)
    |> case do
      :not_found -> false
      _ -> true
    end
  end

  defp add({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
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
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> String.split("")
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        Map.put(acc, {x, y}, char)
      end)
    end)
  end
end
