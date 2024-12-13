defmodule Advent.Day13Test do
  use Advent.Test.Case

  alias Advent.Day13

  @example_input """
  Button A: X+94, Y+34
  Button B: X+22, Y+67
  Prize: X=8400, Y=5400

  Button A: X+26, Y+66
  Button B: X+67, Y+21
  Prize: X=12748, Y=12176

  Button A: X+17, Y+86
  Button B: X+84, Y+37
  Prize: X=7870, Y=6450

  Button A: X+69, Y+23
  Button B: X+27, Y+71
  Prize: X=18641, Y=10279
  """

  @puzzle_input File.read!("puzzle_inputs/day_13.txt")

  describe "part 1" do
    test "example" do
      assert Day13.part_1(@example_input) == 480
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day13.part_1(@puzzle_input) == 28262
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day13.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day13.part_2(@puzzle_input) == :foo
    end
  end
end
