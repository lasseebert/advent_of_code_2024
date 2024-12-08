defmodule Advent.Day08Test do
  use Advent.Test.Case

  alias Advent.Day08

  @example_input """
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
  """

  @puzzle_input File.read!("puzzle_inputs/day_08.txt")

  describe "part 1" do
    test "example" do
      assert Day08.part_1(@example_input) == 14
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day08.part_1(@puzzle_input) == 301
    end
  end

  describe "part 2" do
    test "example" do
      assert Day08.part_2(@example_input) == 34
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day08.part_2(@puzzle_input) == 1019
    end
  end
end
