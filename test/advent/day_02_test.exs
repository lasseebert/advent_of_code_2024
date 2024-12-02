defmodule Advent.Day02Test do
  use Advent.Test.Case

  alias Advent.Day02

  @example_input """
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  """

  @puzzle_input File.read!("puzzle_inputs/day_02.txt")

  describe "part 1" do
    test "example" do
      assert Day02.part_1(@example_input) == 2
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day02.part_1(@puzzle_input) == 269
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day02.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day02.part_2(@puzzle_input) == :foo
    end
  end
end
