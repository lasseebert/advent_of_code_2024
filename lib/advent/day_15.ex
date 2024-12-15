defmodule Advent.Day15 do
  @moduledoc """
  Day 15
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {map, moves} = input |> parse()

    bot = map |> Enum.find(fn {_, tile} -> tile == :bot end) |> elem(0)
    map = Map.put(map, bot, :empty)

    {map, bot}
    |> move(moves)
    |> elem(0)
    |> Enum.filter(fn {_, tile} -> tile == :box end)
    |> Enum.map(fn {pos, _} -> gps_coord(pos) end)
    |> Enum.sum()
  end

  defp gps_coord({x, y}), do: x + 100 * y

  defp move({map, bot}, []), do: {map, bot}

  defp move({map, bot}, [move | moves]) do
    new_bot = add(bot, move)

    case Map.get(map, new_bot) do
      :empty ->
        move({map, new_bot}, moves)

      :wall ->
        move({map, bot}, moves)

      :box ->
        # Remove the box and attempt to add it again after a line of boxes
        new_map = Map.put(map, new_bot, :empty)
        case try_move_boxes(new_map, new_bot, move) do
          {:ok, new_map} -> move({new_map, new_bot}, moves)
          :error -> move({map, bot}, moves)
        end
    end
  end

  defp try_move_boxes(map, pos, move) do
    new_pos = add(pos, move)

    case Map.get(map, new_pos) do
      :empty -> {:ok, Map.put(map, new_pos, :box)}
      :box -> try_move_boxes(map, new_pos, move)
      :wall -> :error
    end
  end

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

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
    |> then(fn [map_input, moves_input] ->
      {
        parse_map(map_input),
        parse_moves(moves_input)
      }
    end)
  end

  defp parse_map(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, map ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {char, x}, map ->
        case char do
          "#" -> Map.put(map, {x, y}, :wall)
          "." -> Map.put(map, {x, y}, :empty)
          "@" -> Map.put(map, {x, y}, :bot)
          "O" -> Map.put(map, {x, y}, :box)
        end
      end)
    end)
  end

  defp parse_moves(input) do
    input
    |> String.replace("\n", "")
    |> String.split("", trim: true)
    |> Enum.map(fn
      "^" -> {0, -1}
      "v" -> {0, 1}
      "<" -> {-1, 0}
      ">" -> {1, 0}
    end)
  end
end
