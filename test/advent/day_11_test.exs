defmodule Advent.Day11Test do
  use Advent.Test.Case

  alias Advent.Day11

  @example_input """
  125 17
  """

  @puzzle_input File.read!("puzzle_inputs/day_11.txt")

  describe "part 1" do
    test "example" do
      assert Day11.part_1(@example_input) == 55312
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day11.part_1(@puzzle_input) == 186_424
    end
  end

  describe "part 2" do
    @tag :puzzle_input
    test "puzzle input" do
      assert Day11.part_2(@puzzle_input) == 219_838_428_124_832
    end
  end
end
