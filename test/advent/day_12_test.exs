defmodule Advent.Day12Test do
  use Advent.Test.Case

  alias Advent.Day12

  @example_input """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  """

  @puzzle_input File.read!("puzzle_inputs/day_12.txt")

  describe "part 1" do
    test "example" do
      assert Day12.part_1(@example_input) == 1930
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day12.part_1(@puzzle_input) == 1_396_562
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day12.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day12.part_2(@puzzle_input) == :foo
    end
  end
end
