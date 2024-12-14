defmodule Advent.Day14Test do
  use Advent.Test.Case

  alias Advent.Day14

  @example_input """
  p=0,4 v=3,-3
  p=6,3 v=-1,-3
  p=10,3 v=-1,2
  p=2,0 v=2,-1
  p=0,0 v=1,3
  p=3,0 v=-2,-2
  p=7,6 v=-1,-3
  p=3,0 v=-1,-2
  p=9,3 v=2,3
  p=7,3 v=-1,2
  p=2,4 v=2,-3
  p=9,5 v=-3,-3
  """

  @puzzle_input File.read!("puzzle_inputs/day_14.txt")

  describe "part 1" do
    test "example" do
      assert Day14.part_1(@example_input, {11, 7}) == 12
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day14.part_1(@puzzle_input, {101, 103}) == 232_589_280
    end
  end

  describe "part 2" do
    @tag :puzzle_input
    @tag timeout: :infinity
    test "puzzle input" do
      assert Day14.part_2(@puzzle_input, {101, 103}) == 7569
    end
  end
end
