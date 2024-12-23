defmodule Advent.Day23Test do
  use Advent.Test.Case

  alias Advent.Day23

  @example_input """
  kh-tc
  qp-kh
  de-cg
  ka-co
  yn-aq
  qp-ub
  cg-tb
  vc-aq
  tb-ka
  wh-tc
  yn-cg
  kh-ub
  ta-co
  de-co
  tc-td
  tb-wq
  wh-td
  ta-ka
  td-qp
  aq-cg
  wq-ub
  ub-vc
  de-ta
  wq-aq
  wq-vc
  wh-yn
  ka-de
  kh-ta
  co-tc
  wh-qp
  tb-vc
  td-yn
  """

  @puzzle_input File.read!("puzzle_inputs/day_23.txt")

  describe "part 1" do
    test "example" do
      assert Day23.part_1(@example_input) == 7
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day23.part_1(@puzzle_input) == 1046
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day23.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day23.part_2(@puzzle_input) == :foo
    end
  end
end
