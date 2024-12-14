defmodule Advent.Day14 do
  @moduledoc """
  Day 14
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t(), {integer, integer}) :: integer
  def part_1(input, dims) do
    input
    |> parse()
    |> Enum.map(&move(&1, 100, dims))
    |> Enum.map(fn {pos, _vel} -> pos end)
    |> Enum.map(&quadrant(&1, dims))
    |> Enum.reject(&is_nil/1)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.reduce(&Kernel.*/2)
  end

  defp move({{x, y}, {vx, vy}}, n, {w, h}) do
    {
      {
        rem(rem(x + vx * n, w) + w, w),
        rem(rem(y + vy * n, h) + h, h)
      },
      {vx, vy}
    }
  end

  defp quadrant({x, y}, {w, h}) do
    mid_x = div(w - 1, 2)
    mid_y = div(h - 1, 2)

    case {x, y} do
      {x, y} when x < mid_x and y < mid_y -> 1
      {x, y} when x > mid_x and y < mid_y -> 2
      {x, y} when x < mid_x and y > mid_y -> 3
      {x, y} when x > mid_x and y > mid_y -> 4
      _ -> nil
    end
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
    |> Enum.map(&parse_robot/1)
  end

  defp parse_robot(line) do
    ~r/^p=(\d+),(\d+) v=(-?\d+),(-?\d+)$/
    |> Regex.run(line, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
    |> then(fn [x, y, vx, vy] -> {{x, y}, {vx, vy}} end)
  end
end
