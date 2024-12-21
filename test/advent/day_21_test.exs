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

    test "small example 6" do
      assert Day21.part_1("973A") == 68 * 973
    end

    test "small example 7" do
      assert Day21.part_1("836A") == 58520
    end

    test "small example 8" do
      assert Day21.part_1("780A") == 51480
    end

    test "small example 9" do
      assert Day21.part_1("985A") == 65010
    end

    test "small example 10" do
      assert Day21.part_1("413A") == 28910
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day21.part_1(@puzzle_input) == 270_084
    end
  end

  describe "part 2" do
    @tag :puzzle_input
    test "puzzle input" do
      assert Day21.part_2(@puzzle_input) > 162_204_717_002_258
      assert Day21.part_2(@puzzle_input) < 407_013_456_261_524
      assert Day21.part_2(@puzzle_input) == :foo
    end
  end
end
