defmodule Advent.Day01 do
  @moduledoc """
  Day 01
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.unzip()
    |> Tuple.to_list()
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip()
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    {list_1, list_2} =
      input
      |> parse()
      |> Enum.unzip()

    list_2_counts =
      list_2
      |> Enum.group_by(& &1)
      |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
      |> Enum.into(%{})

    list_1
    |> Enum.map(fn x -> x * Map.get(list_2_counts, x, 0) end)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)
      |> then(&List.to_tuple/1)
    end)
  end
end
