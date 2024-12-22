defmodule Advent.Day22 do
  @moduledoc """
  Day 22
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&iterate(&1, 2000))
    |> Enum.sum()
  end

  defp iterate(secret, 0), do: secret
  defp iterate(secret, n), do: secret |> generate() |> iterate(n - 1)

  defp generate(secret) do
    a = secret * 64
    secret = secret |> mix(a) |> prune()

    b = div(secret, 32)
    secret = secret |> mix(b) |> prune()

    c = secret * 2048
    secret = secret |> mix(c) |> prune()

    secret
  end

  defp mix(a, b), do: Bitwise.bxor(a, b)
  defp prune(n), do: rem(n, 16_777_216)

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
    |> Enum.map(&String.to_integer/1)
  end
end
