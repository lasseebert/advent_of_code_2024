defmodule Advent.Day07Test do
  use Advent.Test.Case

  alias Advent.Day07

  @example_input """
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
  """

  @puzzle_input File.read!("puzzle_inputs/day_07.txt")

  describe "part 1" do
    test "example" do
      assert Day07.part_1(@example_input) == 3749
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day07.part_1(@puzzle_input) == 20_665_830_408_335
    end
  end

  describe "part 2" do
    test "example" do
      assert Day07.part_2(@example_input) == 11387
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day07.part_2(@puzzle_input) == 354_060_705_047_464
    end
  end
end
