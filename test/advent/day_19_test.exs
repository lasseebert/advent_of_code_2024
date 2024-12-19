defmodule Advent.Day19Test do
  use Advent.Test.Case

  alias Advent.Day19

  @example_input """
  r, wr, b, g, bwu, rb, gb, br

  brwrr
  bggr
  gbbr
  rrbgbr
  ubwu
  bwurrg
  brgr
  bbrgwb
  """

  @puzzle_input File.read!("puzzle_inputs/day_19.txt")

  describe "part 1" do
    test "example" do
      assert Day19.part_1(@example_input) == 6
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day19.part_1(@puzzle_input) == 374
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day19.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day19.part_2(@puzzle_input) == :foo
    end
  end
end
