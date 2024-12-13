defmodule Advent.Day13 do
  @moduledoc """
  Day 13
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&min_tokens/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.map(fn {a, b, {px, py}} ->
      {a, b, {px + 10_000_000_000_000, py + 10_000_000_000_000}}
    end)
    |> Enum.map(&min_tokens/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.sum()
  end

  # We have two equations with two unknowns:
  #
  # px = a * ax + b * bx
  # py = a * ay + b * by
  #
  # Scripling on the paper, I got to:
  #
  # a = (px - b * bx) / ax
  # b = (ax * py - ay * px) / (ax * by - ay * bx)
  #
  # I use this to find integer solutions
  defp min_tokens({{ax, ay}, {bx, by}, {px, py}}) do
    d1 = ax * py - ay * px
    d2 = ax * by - ay * bx

    if rem(d1, d2) == 0 do
      b = div(d1, d2)

      d3 = px - b * bx
      d4 = ax

      if rem(d3, d4) == 0 do
        a = div(d3, d4)

        3 * a + b
      end
    end
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_block/1)
  end

  defp parse_block(input) do
    [a, b, prize] = String.split(input, "\n", trim: true)

    {
      parse_button(a),
      parse_button(b),
      parse_prize(prize)
    }
  end

  defp parse_button(input) do
    ~r/^Button .: X\+(\d+), Y\+(\d+)$/
    |> Regex.run(input, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp parse_prize(input) do
    ~r/^Prize: X=(\d+), Y=(\d+)$/
    |> Regex.run(input, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
