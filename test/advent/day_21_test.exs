defmodule Advent.Day21Test do
  use Advent.Test.Case

  alias Advent.Day21

  @example_input """
  029A
  980A
  179A
  456A
  379A
  """

  @puzzle_input File.read!("puzzle_inputs/day_21.txt")

  describe "part 1" do
    test "example" do
      assert Day21.part_1(@example_input) == 126_384
    end

    test "small example 1" do
      assert Day21.part_1("029A") == 68 * 29
    end

    test "small example 2" do
      assert Day21.part_1("980A") == 60 * 980
    end

    test "small example 3" do
      assert Day21.part_1("179A") == 68 * 179
    end

    test "small example 4" do
      assert Day21.part_1("456A") == 64 * 456
    end

    test "small example 5" do
      assert Day21.part_1("379A") == 64 * 379
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day21.part_1(@puzzle_input) == 270_084
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day21.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day21.part_2(@puzzle_input) == :foo
    end
  end
end
