defmodule Advent.Day10Test do
  use Advent.Test.Case

  alias Advent.Day10

  @example_input """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """

  @puzzle_input File.read!("puzzle_inputs/day_10.txt")

  describe "part 1" do
    test "example" do
      assert Day10.part_1(@example_input) == 36
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day10.part_1(@puzzle_input) == 593
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day10.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day10.part_2(@puzzle_input) == :foo
    end
  end
end
