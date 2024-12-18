defmodule Advent.Day18 do
  @moduledoc """
  Day 18
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t(), {integer, integer}, integer) :: integer
  def part_1(input, goal, limit) do
    walls =
      input
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.take(limit)
      |> Enum.join("\n")
      |> parse()

    a_star(walls, {0, 0}, goal)
  end

  defp a_star(walls, start, goal) do
    queue = PQueue2.new() |> PQueue2.put(start, heuristic(start, goal))
    g_scores = %{} |> Map.put(start, 0)

    a_star(queue, g_scores, walls, goal)
  end

  defp a_star(queue, g_scores, walls, goal) do
    {current, queue} = PQueue2.pop(queue)

    if current == goal do
      Map.fetch!(g_scores, goal)
    else
      current_g = Map.fetch!(g_scores, current)

      {queue, g_scores} =
        current
        |> neighbours(walls, goal)
        |> Enum.reduce({queue, g_scores}, fn neighbour, {queue, g_scores} ->
          g_score = current_g + 1

          case Map.get(g_scores, neighbour) do
            # Current path to the neighbour is the smallest yet
            larger when is_nil(larger) or g_score < larger ->
              g_scores = Map.put(g_scores, neighbour, g_score)
              queue = PQueue2.put(queue, neighbour, g_score + heuristic(neighbour, goal))
              {queue, g_scores}

            _smaller ->
              # Larger distance to the neighbour than previously discovered. Skip.
              {queue, g_scores}
          end
        end)

      a_star(queue, g_scores, walls, goal)
    end
  end

  defp neighbours({x, y}, walls, {max_x, max_y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
    |> Enum.filter(fn {xn, yn} ->
      xn >= 0 and xn <= max_x and yn >= 0 and yn <= max_y and not MapSet.member?(walls, {xn, yn})
    end)
  end

  defp heuristic({x, y}, {goal_x, goal_y}) do
    # Manhattan distance
    abs(x - goal_x) + abs(y - goal_y)
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
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> MapSet.new()
  end
end
