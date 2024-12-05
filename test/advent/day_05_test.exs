defmodule Advent.Day05Test do
  use Advent.Test.Case

  alias Advent.Day05

  @example_input """
  47|53
  97|13
  97|61
  97|47
  75|29
  61|13
  75|53
  29|13
  97|29
  53|29
  61|53
  97|53
  61|29
  47|13
  75|47
  97|75
  47|61
  75|61
  47|29
  75|13
  53|13

  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  75,97,47,61,53
  61,13,29
  97,13,75,29,47
  """

  @puzzle_input File.read!("puzzle_inputs/day_05.txt")

  describe "part 1" do
    test "example" do
      assert Day05.part_1(@example_input) == 143
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day05.part_1(@puzzle_input) == 6612
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day05.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day05.part_2(@puzzle_input) == :foo
    end
  end
end
