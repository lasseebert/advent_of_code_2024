defmodule Advent.Day03 do
  @moduledoc """
  Day 03
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.filter(fn
      {:mul, _a, _b} -> true
      _ -> false
    end)
    |> Enum.map(fn {:mul, a, b} -> a * b end)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.reduce({0, true}, fn
      {:mul, a, b}, {acc, true} -> {acc + a * b, true}
      {:mul, _a, _b}, {acc, false} -> {acc, false}
      :do, {acc, _} -> {acc, true}
      :dont, {acc, _} -> {acc, false}
    end)
    |> then(fn {sum, _} -> sum end)
  end

  defp parse(input) do
    input = input |> String.trim()

    ~r/(mul)\((\d{1,3}),(\d{1,3})\)|(do)\(\)|(don't)\(\)/
    |> Regex.scan(input, capture: :all_but_first)
    |> Enum.map(fn captures -> Enum.filter(captures, &(&1 != "")) end)
    |> Enum.map(fn
      ["mul", a, b] -> {:mul, String.to_integer(a), String.to_integer(b)}
      ["do"] -> :do
      ["don't"] -> :dont
    end)
  end
end
