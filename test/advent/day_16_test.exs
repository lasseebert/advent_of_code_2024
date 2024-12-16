defmodule Advent.Day16Test do
  use Advent.Test.Case

  alias Advent.Day16

  @example_input_1 """
  ###############
  #.......#....E#
  #.#.###.#.###.#
  #.....#.#...#.#
  #.###.#####.#.#
  #.#.#.......#.#
  #.#.#####.###.#
  #...........#.#
  ###.#.#####.#.#
  #...#.....#.#.#
  #.#.#.###.#.#.#
  #.....#...#.#.#
  #.###.#.#.#.#.#
  #S..#.....#...#
  ###############
  """

  @example_input_2 """
  #################
  #...#...#...#..E#
  #.#.#.#.#.#.#.#.#
  #.#.#.#...#...#.#
  #.#.#.#.###.#.#.#
  #...#.#.#.....#.#
  #.#.#.#.#.#####.#
  #.#...#.#.#.....#
  #.#.#####.#.###.#
  #.#.#.......#...#
  #.#.###.#####.###
  #.#.#...#.....#.#
  #.#.#.#####.###.#
  #.#.#.........#.#
  #.#.#.#########.#
  #S#.............#
  #################
  """

  @puzzle_input File.read!("puzzle_inputs/day_16.txt")

  describe "part 1" do
    test "example 1" do
      assert Day16.part_1(@example_input_1) == 7036
    end

    test "example 2" do
      assert Day16.part_1(@example_input_2) == 11048
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day16.part_1(@puzzle_input) == 143_564
    end
  end

  describe "part 2" do
    @tag :skip
    test "example 1" do
      assert Day16.part_2(@example_input_1) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day16.part_2(@puzzle_input) == :foo
    end
  end
end
