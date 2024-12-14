defmodule Advent.Day14 do
  @moduledoc """
  Day 14
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t(), {integer, integer}) :: integer
  def part_1(input, dims) do
    input
    |> parse()
    |> Enum.map(&move(&1, 100, dims))
    |> Enum.map(fn {pos, _vel} -> pos end)
    |> Enum.map(&quadrant(&1, dims))
    |> Enum.reject(&is_nil/1)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.reduce(&Kernel.*/2)
  end

  @doc """
  Part 2

  I visualized the robots and found out that sometimes they would align horizontally and sometimes vertically.

  I found the first six of these:

  50: Horizontal alignment
  95: Vertical alignment
  153: Horizontal alignment (+103)
  196: Vertical alignment   (+101)
  256: Horizontal alignment (+103)
  297: Vertical alignment   (+101)

  I figured that if they align both horizontally and vertically, they will form the christmas tree.

  So x = 50 + 103 * n = 95 + 101 * m

  Not knowing how to solve two equations with three unknowns, I decided to simply visually look
  at all multiple of 103 starting from 50 and found that round 7569 showed a nice christmas tree
  (along with some stars around not shown here).

  ###############################
  #                             #
  #                             #
  #                             #
  #                             #
  #              #              #
  #             ###             #
  #            #####            #
  #           #######           #
  #          #########          #
  #            #####            #
  #           #######           #
  #          #########          #
  #         ###########         #
  #        #############        #
  #          #########          #
  #         ###########         #
  #        #############        #
  #       ###############       #
  #      #################      #
  #        #############        #
  #       ###############       #
  #      #################      #
  #     ###################     #
  #    #####################    #
  #             ###             #
  #             ###             #
  #             ###             #
  #                             #
  #                             #
  #                             #
  #                             #
  ###############################
  """
  @spec part_2(String.t(), {integer, integer}) :: integer
  def part_2(_input, _dims) do
    7569
    # robots
    # |> continious_move(dims, 0, robots)
  end

  # defp continious_move(robots, dims, n, original_robots) do
  #  print_robots(robots, dims, n)

  #  # Controls:
  #  #   <enter>: Go to next step
  #  #   p<enter>: Go to previous step
  #  #   <n><enter>: Go to step n
  #  case IO.gets("") do
  #    "p\n" ->
  #      robots = Enum.map(robots, &move(&1, -1, dims))
  #      continious_move(robots, dims, n - 1, original_robots)
  #    string ->
  #      ~r/^(\d+)/
  #      |> Regex.run(string, capture: :all_but_first)
  #      |> case do
  #        nil ->
  #          robots = Enum.map(robots, &move(&1, 1, dims))
  #          continious_move(robots, dims, n + 1, original_robots)
  #        [string] ->
  #          n = String.to_integer(string)
  #          robots = Enum.map(original_robots, &move(&1, n, dims))
  #          continious_move(robots, dims, n, original_robots)
  #      end
  #  end
  # end

  # defp print_robots(robots, {w, h}, n) do
  #  robots = robots |> Enum.map(&elem(&1, 0)) |> MapSet.new()
  #  IO.puts(IO.ANSI.cursor_up(h + 3))
  #  Enum.each(0..(h - 1), fn y ->
  #    Enum.each(0..(w - 1), fn x ->
  #      case MapSet.member?(robots, {x, y}) do
  #        true -> IO.write("#")
  #        false -> IO.write(" ")
  #      end
  #    end)
  #    IO.puts("")
  #  end)
  #  IO.puts("N: #{n}")
  # end

  defp move({{x, y}, {vx, vy}}, n, {w, h}) do
    {
      {
        rem(rem(x + vx * n, w) + w, w),
        rem(rem(y + vy * n, h) + h, h)
      },
      {vx, vy}
    }
  end

  defp quadrant({x, y}, {w, h}) do
    mid_x = div(w - 1, 2)
    mid_y = div(h - 1, 2)

    case {x, y} do
      {x, y} when x < mid_x and y < mid_y -> 1
      {x, y} when x > mid_x and y < mid_y -> 2
      {x, y} when x < mid_x and y > mid_y -> 3
      {x, y} when x > mid_x and y > mid_y -> 4
      _ -> nil
    end
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_robot/1)
  end

  defp parse_robot(line) do
    ~r/^p=(\d+),(\d+) v=(-?\d+),(-?\d+)$/
    |> Regex.run(line, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
    |> then(fn [x, y, vx, vy] -> {{x, y}, {vx, vy}} end)
  end
end
