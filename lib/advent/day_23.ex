defmodule Advent.Day23 do
  @moduledoc """
  Day 23
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> build_graph()
    |> find_triplets()
    |> Enum.filter(fn triplet -> Enum.any?(triplet, fn node -> String.starts_with?(node, "t") end) end)
    |> Enum.count()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: String.t()
  def part_2(input) do
    input
    |> parse()
    |> build_graph()
    |> find_largest_group()
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp find_largest_group(graph) do
    upper_bound = graph |> Map.values() |> Enum.map(&Enum.count/1) |> Enum.max() |> Kernel.+(1)

    find_largest_group(graph, upper_bound)
  end

  defp find_largest_group(graph, upper_bound) do
    case find_group(graph, upper_bound) do
      nil -> find_largest_group(graph, upper_bound - 1)
      group -> group
    end
  end

  defp find_group(graph, size) do
    possible_super_groups =
      graph
      |> Enum.map(fn {node, neighbours} -> Enum.sort([node | MapSet.to_list(neighbours)]) end)
      |> Enum.uniq()

    possible_super_groups
    |> Enum.flat_map(fn super_group ->
      if length(super_group) < size do
        []
      else
        combinations(super_group, size)
      end
    end)
    |> Enum.uniq()
    |> Enum.find(fn group -> group?(graph, group) end)
  end

  defp group?(graph, group) do
    Enum.all?(group, fn node ->
      group
      |> List.delete(node)
      |> Enum.all?(fn neighbour ->
        graph
        |> Map.fetch!(node)
        |> MapSet.member?(neighbour)
      end)
    end)
  end

  defp build_graph(input), do: build_graph(%{}, input)
  defp build_graph(map, []), do: map

  defp build_graph(map, [{a, b} | rest]) do
    map
    |> Map.update(a, MapSet.new([b]), &MapSet.put(&1, b))
    |> Map.update(b, MapSet.new([a]), &MapSet.put(&1, a))
    |> build_graph(rest)
  end

  defp find_triplets(graph) do
    # Naive approach:
    # For each node, for each pair of neighbours, if they are connected, add the triplet to the list
    graph
    |> Enum.flat_map(fn {node, neighbours} ->
      neighbours
      |> Enum.to_list()
      |> combinations(2)
      |> Enum.flat_map(fn [n1, n2] ->
        graph
        |> Map.fetch!(n1)
        |> MapSet.member?(n2)
        |> case do
          true ->
            triplet = Enum.sort([node, n1, n2])
            [triplet]

          false ->
            []
        end
      end)
    end)
    |> Enum.uniq()
  end

  defp combinations(_list, 0), do: [[]]
  defp combinations([], _), do: []

  defp combinations([head | tail], n) do
    tail_comb = combinations(tail, n)
    head_comb = combinations(tail, n - 1) |> Enum.map(&[head | &1])

    tail_comb ++ head_comb
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("-")
      |> List.to_tuple()
    end)
  end
end
