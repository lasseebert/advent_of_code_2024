defmodule Advent.Day21 do
  @moduledoc """
  Day 21
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(fn code ->
      code
      |> digit_path()
      |> arrow_path()
      |> arrow_path()
      |> Enum.min_by(&length/1)
      |> complexity(code)
    end)
    |> Enum.sum()
  end

  defp complexity(presses, code) do
    code_number = code |> Enum.take(3) |> Enum.reduce(0, fn n, acc -> acc * 10 + n end)
    length(presses) * code_number
  end

  defp digit_path(digits) do
    ["A" | digits]
    |> Enum.map(&digit_position/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [source, target] -> presses(source, target, {0, 3}) end)
    |> unpack()
  end

  defp arrow_path(press_series) do
    press_series
    |> Enum.flat_map(fn presses ->
      ["A" | presses]
      |> Enum.map(&arrow_position/1)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [source, target] -> presses(source, target, {0, 0}) end)
      |> unpack()
    end)
  end

  defp unpack([]), do: [[]]

  defp unpack([first | rest]) do
    rest
    |> unpack()
    |> Enum.flat_map(fn tail ->
      first
      |> Enum.map(&(&1 ++ tail))
    end)
  end

  # Same field
  defp presses(pos, pos, _disallowed), do: [["A"]]

  # Stright lines
  defp presses({x, y1}, {x, y2}, _) when y1 < y2, do: [List.duplicate("v", y2 - y1) ++ ["A"]]
  defp presses({x, y1}, {x, y2}, _) when y1 > y2, do: [List.duplicate("^", y1 - y2) ++ ["A"]]
  defp presses({x1, y}, {x2, y}, _) when x1 < x2, do: [List.duplicate(">", x2 - x1) ++ ["A"]]
  defp presses({x1, y}, {x2, y}, _) when x1 > x2, do: [List.duplicate("<", x1 - x2) ++ ["A"]]

  # These four cases cover when the forbidden square could be touched
  defp presses({0, y1}, {x2, y}, {0, y}) when y1 < y do
    [List.duplicate(">", x2) ++ List.duplicate("^", y - y1) ++ ["A"]]
  end

  defp presses({0, y1}, {x2, y}, {0, y}) when y1 > y do
    [List.duplicate(">", x2) ++ List.duplicate("v", y1 - y) ++ ["A"]]
  end

  defp presses({x1, y}, {0, y2}, {0, y}) when y < y2 do
    [List.duplicate("v", y2 - y) ++ List.duplicate("<", x1) ++ ["A"]]
  end

  defp presses({x1, y}, {0, y2}, {0, y}) when y > y2 do
    [List.duplicate("^", y - y2) ++ List.duplicate("<", x1) ++ ["A"]]
  end

  # Cases where there are two directions to go. Use both
  defp presses({x1, y1}, {x2, y2}, _) when x1 < x2 and y1 < y2 do
    [
      List.duplicate(">", x2 - x1) ++ List.duplicate("v", y2 - y1) ++ ["A"],
      List.duplicate("v", y2 - y1) ++ List.duplicate(">", x2 - x1) ++ ["A"]
    ]
  end

  defp presses({x1, y1}, {x2, y2}, _) when x1 < x2 and y1 > y2 do
    [
      List.duplicate(">", x2 - x1) ++ List.duplicate("^", y1 - y2) ++ ["A"],
      List.duplicate("^", y1 - y2) ++ List.duplicate(">", x2 - x1) ++ ["A"]
    ]
  end

  defp presses({x1, y1}, {x2, y2}, _) when x1 > x2 and y1 < y2 do
    [
      List.duplicate("<", x1 - x2) ++ List.duplicate("v", y2 - y1) ++ ["A"],
      List.duplicate("v", y2 - y1) ++ List.duplicate("<", x1 - x2) ++ ["A"]
    ]
  end

  defp presses({x1, y1}, {x2, y2}, _) when x1 > x2 and y1 > y2 do
    [
      List.duplicate("<", x1 - x2) ++ List.duplicate("^", y1 - y2) ++ ["A"],
      List.duplicate("^", y1 - y2) ++ List.duplicate("<", x1 - x2) ++ ["A"]
    ]
  end

  defp digit_position(7), do: {0, 0}
  defp digit_position(8), do: {1, 0}
  defp digit_position(9), do: {2, 0}
  defp digit_position(4), do: {0, 1}
  defp digit_position(5), do: {1, 1}
  defp digit_position(6), do: {2, 1}
  defp digit_position(1), do: {0, 2}
  defp digit_position(2), do: {1, 2}
  defp digit_position(3), do: {2, 2}
  defp digit_position(0), do: {1, 3}
  defp digit_position("A"), do: {2, 3}

  defp arrow_position("^"), do: {1, 0}
  defp arrow_position("A"), do: {2, 0}
  defp arrow_position("<"), do: {0, 1}
  defp arrow_position("v"), do: {1, 1}
  defp arrow_position(">"), do: {2, 1}

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
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(fn
        "0" -> 0
        "1" -> 1
        "2" -> 2
        "3" -> 3
        "4" -> 4
        "5" -> 5
        "6" -> 6
        "7" -> 7
        "8" -> 8
        "9" -> 9
        "A" -> "A"
      end)
    end)
  end
end
