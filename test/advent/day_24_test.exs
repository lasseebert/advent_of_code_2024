defmodule Advent.Day24Test do
  use Advent.Test.Case

  alias Advent.Day24

  @example_input_1 """
  x00: 1
  x01: 1
  x02: 1
  y00: 0
  y01: 1
  y02: 0

  x00 AND y00 -> z00
  x01 XOR y01 -> z01
  x02 OR y02 -> z02
  """

  @example_input_2 """
  x00: 1
  x01: 0
  x02: 1
  x03: 1
  x04: 0
  y00: 1
  y01: 1
  y02: 1
  y03: 1
  y04: 1

  ntg XOR fgs -> mjb
  y02 OR x01 -> tnw
  kwq OR kpj -> z05
  x00 OR x03 -> fst
  tgd XOR rvg -> z01
  vdt OR tnw -> bfw
  bfw AND frj -> z10
  ffh OR nrd -> bqk
  y00 AND y03 -> djm
  y03 OR y00 -> psh
  bqk OR frj -> z08
  tnw OR fst -> frj
  gnj AND tgd -> z11
  bfw XOR mjb -> z00
  x03 OR x00 -> vdt
  gnj AND wpb -> z02
  x04 AND y00 -> kjc
  djm OR pbm -> qhw
  nrd AND vdt -> hwm
  kjc AND fst -> rvg
  y04 OR y02 -> fgs
  y01 AND x02 -> pbm
  ntg OR kjc -> kwq
  psh XOR fgs -> tgd
  qhw XOR tgd -> z09
  pbm OR djm -> kpj
  x03 XOR y03 -> ffh
  x00 XOR y04 -> ntg
  bfw OR bqk -> z06
  nrd XOR fgs -> wpb
  frj XOR qhw -> z04
  bqk OR frj -> z07
  y03 OR x01 -> nrd
  hwm AND bqk -> z03
  tgd XOR rvg -> z12
  tnw OR pbm -> gnj
  """

  @puzzle_input File.read!("puzzle_inputs/day_24.txt")

  describe "part 1" do
    test "example 1" do
      assert Day24.part_1(@example_input_1) == 4
    end

    test "example 2" do
      assert Day24.part_1(@example_input_2) == 2024
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day24.part_1(@puzzle_input) == 65_740_327_379_952
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day24.part_2(@example_input_1) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day24.part_2(@puzzle_input) == :foo
    end
  end
end
