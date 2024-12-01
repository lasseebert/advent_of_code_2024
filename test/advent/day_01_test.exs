defmodule Advent.Day01Test do
  use Advent.Test.Case

  alias Advent.Day01

  @example_input """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """

  @puzzle_input File.read!("puzzle_inputs/day_01.txt")

  describe "part 1" do
    test "example" do
      assert Day01.part_1(@example_input) == 11
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day01.part_1(@puzzle_input) == 1_579_939
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day01.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day01.part_2(@puzzle_input) == :foo
    end
  end
end
