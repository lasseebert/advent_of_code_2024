defmodule Advent.Day24 do
  @moduledoc """
  Day 24
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> resolve_gates()
    |> read_z_wires()
  end

  defp resolve_gates({wires, gates}) do
    wires = Enum.into(wires, %{})

    resolve_gates(gates, [], wires)
  end

  defp resolve_gates([], [], wires), do: wires
  defp resolve_gates([], next_round, wires), do: resolve_gates(next_round, [], wires)

  defp resolve_gates([{{op, a, b}, c} = gate | rest], next_round, wires) do
    if Map.has_key?(wires, a) && Map.has_key?(wires, b) do
      result = apply_gate(op, Map.fetch!(wires, a), Map.fetch!(wires, b))
      resolve_gates(rest, next_round, Map.put(wires, c, result))
    else
      resolve_gates(rest, [gate | next_round], wires)
    end
  end

  defp apply_gate(:and, a, b), do: Bitwise.band(a, b)
  defp apply_gate(:or, a, b), do: Bitwise.bor(a, b)
  defp apply_gate(:xor, a, b), do: Bitwise.bxor(a, b)

  defp read_z_wires(wires) do
    wires
    |> Map.keys()
    |> Enum.filter(fn wire -> String.starts_with?(wire, "z") end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.map(&Map.fetch!(wires, &1))
    |> Enum.reduce(0, &(&2 * 2 + &1))
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
    |> then(fn [wires, gates] ->
      {
        parse_wires(wires),
        parse_gates(gates)
      }
    end)
  end

  defp parse_wires(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_wire/1)
  end

  defp parse_wire(line) do
    ~r/^([a-z0-9]{3}): ([01])$/
    |> Regex.run(line, capture: :all_but_first)
    |> then(fn [name, value] -> {name, String.to_integer(value)} end)
  end

  defp parse_gates(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_gate/1)
  end

  defp parse_gate(line) do
    ~r/^([a-z0-9]{3}) (AND|OR|XOR) ([a-z0-9]{3}) -> ([a-z0-9]{3})$/
    |> Regex.run(line, capture: :all_but_first)
    |> then(fn [x, op, y, z] ->
      op =
        case op do
          "AND" -> :and
          "OR" -> :or
          "XOR" -> :xor
        end

      {{op, x, y}, z}
    end)
  end
end
