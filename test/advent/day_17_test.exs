defmodule Advent.Day17Test do
  use Advent.Test.Case

  alias Advent.Day17

  @example_input """
  Register A: 729
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0
  """

  @puzzle_input File.read!("puzzle_inputs/day_17.txt")

  describe "part 1" do
    test "example" do
      assert Day17.part_1(@example_input) == "4,6,3,5,6,3,5,2,1,0"
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day17.part_1(@puzzle_input) == "6,4,6,0,4,5,7,2,7"
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day17.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day17.part_2(@puzzle_input) == :foo
    end
  end
end
