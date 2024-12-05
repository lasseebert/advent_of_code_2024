defmodule Advent.Day05 do
  @moduledoc """
  Day 05
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {deps, pages} = input |> parse()

    # Build a map of %{page, set of deps}
    deps_map =
      Enum.reduce(deps, %{}, fn {a, b}, acc ->
        Map.update(acc, a, MapSet.new([b]), &MapSet.put(&1, b))
      end)

    pages
    |> Enum.filter(&valid_pages?(&1, deps_map))
    |> Enum.map(&middle_page/1)
    |> Enum.sum()
  end

  defp valid_pages?([_last_page], _deps_map), do: true

  defp valid_pages?([page, next_page | pages], deps_map) do
    page_rules = Map.get(deps_map, page, MapSet.new())

    if MapSet.member?(page_rules, next_page) do
      valid_pages?([next_page | pages], deps_map)
    else
      false
    end
  end

  defp middle_page(pages) do
    Enum.at(pages, div(Enum.count(pages), 2))
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
    |> then(fn [section_1, section_2] ->
      {
        parse_deps(section_1),
        parse_pages(section_2)
      }
    end)
  end

  defp parse_deps(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("|")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp parse_pages(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
