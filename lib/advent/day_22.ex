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
    |> Enum.map(fn starting_number ->
      starting_number
      |> Stream.unfold(&{&1, generate(&1)})
      |> Enum.at(2000)
    end)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    monkeys =
      input
      |> parse()
      |> Enum.map(fn starting_number ->
        starting_number
        |> Stream.unfold(&{&1, generate(&1)})
        |> Stream.map(&rem(&1, 10))
        |> Enum.take(2001)
      end)

    monkeys
    # |> then(fn _ -> end)
    |> Enum.flat_map(fn monkey ->
      monkey
      |> Enum.chunk_every(5, 1, :discard)
      |> Enum.map(fn [a, b, c, d, e] -> [b - a, c - b, d - c, e - d] end)

      # |> Enum.filter(fn [_, _, _, d4] -> d4 > 0 end)
    end)
    |> Enum.uniq()
    # |> then(fn _ -> [[-2, 1, -1, 3]] end)
    |> Enum.map(fn candidate ->
      sum =
        monkeys
        |> Enum.map(fn monkey -> calc_bananas(monkey, candidate) end)
        |> IO.inspect(label: "bananas")
        |> Enum.sum()

      {candidate, sum}
    end)
    |> Enum.max_by(&elem(&1, 1))
  end

  defp calc_bananas(monkey, candidate) do
    monkey
    |> Enum.chunk_every(5, 1, :discard)
    |> Enum.find(fn [a, b, c, d, e] ->
      [b - a, c - b, d - c, e - d] == candidate
    end)
    |> case do
      nil -> 0
      [_, _, _, _, fifth] -> fifth
    end
  end

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

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
