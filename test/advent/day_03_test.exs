defmodule Advent.Day03Test do
  use Advent.Test.Case

  alias Advent.Day03

  @example_input_1 """
  xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  """

  @example_input_2 """
  xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
  """

  @puzzle_input File.read!("puzzle_inputs/day_03.txt")

  describe "part 1" do
    test "example" do
      assert Day03.part_1(@example_input_1) == 161
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day03.part_1(@puzzle_input) == 164_730_528
    end
  end

  describe "part 2" do
    test "example" do
      assert Day03.part_2(@example_input_2) == 48
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day03.part_2(@puzzle_input) == 70_478_672
    end
  end
end
