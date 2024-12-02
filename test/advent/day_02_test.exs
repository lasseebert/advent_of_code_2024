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
    test "example" do
      assert Day02.part_2(@example_input) == 4
    end

    test "with bad level at start" do
      assert Day02.part_2("8 2 3 4 5") == 1
    end

    test "with bad level at start and middle" do
      assert Day02.part_2("8 2 3 3 4 5") == 0
    end

    test "with bad level at end" do
      assert Day02.part_2("1 2 3 4 3") == 1
    end

    test "with bad level at end and middle" do
      assert Day02.part_2("1 2 2 3 4 3") == 0
    end

    test "with bad level at start and end" do
      assert Day02.part_2("4 1 2 3 4 3") == 0
    end

    test "with a bad level in the middle" do
      assert Day02.part_2("1 2 3 9 4 5") == 1
    end

    test "with two consecutive bad levels" do
      assert Day02.part_2("1 2 3 9 9 4 5") == 0
    end

    test "with two bad levels" do
      assert Day02.part_2("1 2 9 3 9 4 5") == 0
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day02.part_2(@puzzle_input) == 337
    end
  end
end
