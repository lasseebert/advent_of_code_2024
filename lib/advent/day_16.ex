defmodule Advent.Day16 do
  @moduledoc """
  Day 16
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {map, source, goal} = input |> parse()

    dir = {1, 0}
    pos = {source, dir}

    queue = PQueue2.new() |> PQueue2.put(pos, heuristic(pos, goal))
    g_scores = %{} |> Map.put(pos, 0)

    a_star(queue, g_scores, map, goal)
  end

  defp a_star(queue, g_scores, map, goal) do
    {current, queue} = PQueue2.pop(queue)
    {pos, _dir} = current

    if pos == goal do
      Map.fetch!(g_scores, current)
    else
      current_g = Map.fetch!(g_scores, current)

      {queue, g_scores} =
        current
        |> neighbours(map)
        |> Enum.reduce({queue, g_scores}, fn {neighbour, distance}, {queue, g_scores} ->
          g_score = current_g + distance

          case Map.fetch(g_scores, neighbour) do
            :error ->
              g_scores = Map.put(g_scores, neighbour, g_score)
              queue = PQueue2.put(queue, neighbour, g_score + heuristic(neighbour, goal))
              {queue, g_scores}

            {:ok, larger} when g_score < larger ->
              g_scores = Map.put(g_scores, neighbour, g_score)
              queue = PQueue2.put(queue, neighbour, g_score + heuristic(neighbour, goal))
              {queue, g_scores}

            {:ok, _smaller} ->
              {queue, g_scores}
          end
        end)

      a_star(queue, g_scores, map, goal)
    end
  end

  defp neighbours({{x, y}, {dx, dy}}, map) do
    # We can turn left, turn right or go straight
    # We can only go straight if there is no wall in front of us
    wall = MapSet.member?(map, {x + dx, y + dy})

    [
      {{{x, y}, turn_left({dx, dy})}, 1000},
      {{{x, y}, turn_right({dx, dy})}, 1000},
      if(not wall, do: {{{x + dx, y + dy}, {dx, dy}}, 1})
    ]
    |> Enum.reject(&is_nil/1)
  end

  defp turn_left({1, 0}), do: {0, 1}
  defp turn_left({0, 1}), do: {-1, 0}
  defp turn_left({-1, 0}), do: {0, -1}
  defp turn_left({0, -1}), do: {1, 0}

  defp turn_right({1, 0}), do: {0, -1}
  defp turn_right({0, 1}), do: {1, 0}
  defp turn_right({-1, 0}), do: {0, 1}
  defp turn_right({0, -1}), do: {-1, 0}

  defp heuristic({{x1, y1}, {dx, dy}}, {x2, y2}) do
    # Heuristic for turning is as follows:
    # * When facing the goal in a straight line, we don't need to turn
    # * When facing towards one of the coordinates, we need to turn once
    # * When facing away from the goal, we need to turn twice

    turns =
      case {{dx, dy}, {x2 - x1, y2 - y1}} do
        {{1, 0}, {n, 0}} when n > 0 -> 0
        {{1, 0}, {n, _}} when n < 0 -> 2
        {{1, 0}, _} -> 1
        {{-1, 0}, {n, 0}} when n < 0 -> 0
        {{-1, 0}, {n, _}} when n > 0 -> 2
        {{-1, 0}, _} -> 1
        {{0, 1}, {0, n}} when n > 0 -> 0
        {{0, 1}, {_, n}} when n < 0 -> 2
        {{0, 1}, _} -> 1
        {{0, -1}, {0, n}} when n < 0 -> 0
        {{0, -1}, {_, n}} when n > 0 -> 2
        {{0, -1}, _} -> 1
      end

    manhattan = abs(x1 - x2) + abs(y1 - y2)

    turns * 1000 + manhattan
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
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({MapSet.new(), nil, nil}, fn {line, y}, {map, source, goal} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce({map, source, goal}, fn {char, x}, {map, source, goal} ->
        case char do
          "S" -> {map, {x, y}, goal}
          "E" -> {map, source, {x, y}}
          "#" -> {MapSet.put(map, {x, y}), source, goal}
          "." -> {map, source, goal}
        end
      end)
    end)
  end
end
