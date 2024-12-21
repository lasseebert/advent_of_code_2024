defmodule Advent.Day21 do
  @moduledoc """
  Day 21
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    solve(input, 2)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    solve(input, 25)
  end

  defp solve(input, num_keypads) do
    input
    |> parse()
    |> Enum.map(&complexity(&1, num_keypads))
    |> Enum.sum()
  end

  defp complexity(code, num_keypads) do
    code_number = code |> Enum.take(3) |> Enum.reduce(0, fn n, acc -> acc * 10 + n end)

    press_series = code |> digit_path()

    final_length =
      press_series
      |> Enum.map(fn presses ->
        final_length(presses, num_keypads, %{})
        |> elem(1)
      end)
      |> Enum.min()

    code_number * final_length
  end

  defp final_length(presses, 0, cache), do: {cache, length(presses)}

  defp final_length(presses, num_keypads, cache) do
    # IO.inspect({presses, num_keypads, cache}, label: "final_length")
    # Split list into multiple lists on "A"
    presses
    |> Enum.chunk_while(
      [],
      fn x, acc ->
        if x == "A" do
          {:cont, Enum.reverse([x | acc]), []}
        else
          {:cont, [x | acc]}
        end
      end,
      fn [] -> {:cont, []} end
    )
    # |> IO.inspect(label: "chunk_while")
    |> Enum.reduce({cache, 0}, fn list, {cache, sum} ->
      # IO.inspect(list, label: "list")
      {cache, len} = single_final_length(list, num_keypads, cache)
      {cache, sum + len}
    end)
  end

  defp single_final_length(presses, num_keypads, cache) do
    # IO.inspect({presses, num_keypads, cache}, label: "single_final_length")
    case Map.fetch(cache, {presses, num_keypads}) do
      {:ok, value} ->
        # IO.puts("In cache!")
        {cache, value}

      :error ->
        # IO.puts("Not in cache")
        {cache, value} =
          ["A" | presses]
          |> arrow_path()
          |> Enum.reduce({cache, nil}, fn list, {cache, min} ->
            {cache, len} = final_length(list, num_keypads - 1, cache)

            min =
              case min do
                nil -> len
                _ -> Enum.min([min, len])
              end

            {cache, min}
          end)

        # IO.inspect({Enum.count(cache), presses, value, num_keypads}, label: "single_final_length")
        # Process.sleep(100)
        {Map.put(cache, {presses, num_keypads}, value), value}
    end
  end

  def digit_path(digits) do
    ["A" | digits]
    |> Enum.map(&digit_position/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [source, target] -> presses(source, target, {0, 3}) end)
    |> unpack()
  end

  def arrow_path(presses) do
    presses
    |> Enum.map(&arrow_position/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [source, target] -> presses(source, target, {0, 0}) end)
    |> unpack()
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
