defmodule Advent.Day18Test do
  use Advent.Test.Case

  alias Advent.Day18

  @example_input """
  5,4
  4,2
  4,5
  3,0
  2,1
  6,3
  2,4
  1,5
  0,6
  3,3
  2,6
  5,1
  1,2
  5,5
  2,5
  6,5
  1,4
  0,4
  6,4
  1,1
  6,1
  1,0
  0,5
  1,6
  2,0
  """

  @puzzle_input File.read!("puzzle_inputs/day_18.txt")

  describe "part 1" do
    test "example" do
      assert Day18.part_1(@example_input, {6, 6}, 12) == 22
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day18.part_1(@puzzle_input, {70, 70}, 1024) == 292
    end
  end

  describe "part 2" do
    test "example" do
      assert Day18.part_2(@example_input, {6, 6}) == "6,1"
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day18.part_2(@puzzle_input, {70, 70}) == "58,44"
    end
  end
end
