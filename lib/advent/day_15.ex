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

    map
    |> move_1(bot, moves)
    |> Enum.filter(fn {_, tile} -> tile == :box end)
    |> Enum.map(fn {pos, _} -> gps_coord(pos) end)
    |> Enum.sum()
  end

  defp move_1(map, _bot, []), do: map

  defp move_1(map, bot, [move | moves]) do
    case try_move_1(map, bot, move) do
      {:ok, new_map} -> move_1(new_map, add(bot, move), moves)
      :error -> move_1(map, bot, moves)
    end
  end

  defp try_move_1(map, pos, move) do
    new_pos = add(pos, move)

    case Map.get(map, new_pos) do
      :wall ->
        :error

      :empty ->
        thing = Map.get(map, pos)
        new_map = map |> Map.put(pos, :empty) |> Map.put(new_pos, thing)
        {:ok, new_map}

      :box ->
        case try_move_1(map, new_pos, move) do
          :error ->
            :error

          {:ok, new_map} ->
            thing = Map.get(map, pos)
            new_map = new_map |> Map.put(pos, :empty) |> Map.put(new_pos, thing)
            {:ok, new_map}
        end
    end
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    {map, moves} = input |> widen() |> parse()

    bot = map |> Enum.find(fn {_, tile} -> tile == :bot end) |> elem(0)

    map
    |> move_2(bot, moves)
    |> Enum.filter(fn {_, tile} -> tile == :left_box end)
    |> Enum.map(fn {pos, _} -> gps_coord(pos) end)
    |> Enum.sum()
  end

  defp move_2(map, _bot, []), do: map

  defp move_2(map, bot, [move | moves]) do
    case try_move_2(map, bot, move) do
      {:ok, new_map} -> move_2(new_map, add(bot, move), moves)
      :error -> move_2(map, bot, moves)
    end
  end

  defp try_move_2(map, pos, move) do
    next = add(pos, move)

    case {Map.get(map, next), move} do
      # When we hit a box going vertical, we also recurse on the other part of the box
      {:left_box, {0, _}} -> [next, add(next, {1, 0})]
      {:right_box, {0, _}} -> [next, add(next, {-1, 0})]
      _ -> [next]
    end
    |> Enum.reduce({:ok, map}, fn
      _, :error ->
        :error

      new_pos, {:ok, map} ->
        case Map.fetch!(map, new_pos) do
          :wall -> :error
          :empty -> {:ok, map}
          box when box in [:left_box, :right_box] -> try_move_2(map, new_pos, move)
        end
    end)
    |> case do
      :error ->
        :error

      {:ok, new_map} ->
        thing = Map.get(map, pos)
        {:ok, new_map |> Map.put(pos, :empty) |> Map.update!(next, fn :empty -> thing end)}
    end
  end

  defp gps_coord({x, y}), do: x + 100 * y
  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  defp widen(input) do
    input
    |> String.replace("#", "##")
    |> String.replace("O", "[]")
    |> String.replace(".", "..")
    |> String.replace("@", "@.")
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
          "[" -> Map.put(map, {x, y}, :left_box)
          "]" -> Map.put(map, {x, y}, :right_box)
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
