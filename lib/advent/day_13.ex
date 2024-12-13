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

  defp min_tokens({a, b, prize}) do
    # Most naive solution in the world
    for(ca <- 0..100, cb <- 0..100, do: {ca, cb})
    |> Enum.map(&try_combination(&1, a, b, prize))
    |> Enum.reject(&is_nil/1)
    |> case do
      [] -> nil
      list -> Enum.min(list)
    end
  end

  defp try_combination({ca, cb}, {xa, ya}, {xb, yb}, {xp, yp}) do
    if ca * xa + cb * xb == xp && ca * ya + cb * yb == yp do
      3 * ca + cb
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
