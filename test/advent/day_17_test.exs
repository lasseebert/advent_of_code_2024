defmodule Advent.Day17Test do
  use Advent.Test.Case

  alias Advent.Day17

  @example_input_1 """
  Register A: 729
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0
  """

  @example_input_2 """
  Register A: 2024
  Register B: 0
  Register C: 0

  Program: 0,3,5,4,3,0
  """

  @puzzle_input File.read!("puzzle_inputs/day_17.txt")

  describe "part 1" do
    test "example" do
      assert Day17.part_1(@example_input_1) == "4,6,3,5,6,3,5,2,1,0"
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day17.part_1(@puzzle_input) == "6,4,6,0,4,5,7,2,7"
    end
  end

  describe "part 2" do
    test "example" do
      assert Day17.part_2(@example_input_2) == 117_440
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day17.part_2(@puzzle_input) == 164_541_160_582_845
    end
  end
end
