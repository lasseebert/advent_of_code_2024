defmodule Advent.Day22Test do
  use Advent.Test.Case

  alias Advent.Day22

  @example_input """
  1
  10
  100
  2024
  """

  @puzzle_input File.read!("puzzle_inputs/day_22.txt")

  describe "part 1" do
    test "example" do
      assert Day22.part_1(@example_input) == 37_327_623
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day22.part_1(@puzzle_input) == 14_623_556_510
    end
  end

  describe "part 2" do
    test "example" do
      assert Day22.part_2(@example_input) == 23
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day22.part_2(@puzzle_input) == :foo
    end
  end
end
