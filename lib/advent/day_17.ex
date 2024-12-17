defmodule Advent.Day17 do
  @moduledoc """
  Day 17
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: String.t()
  def part_1(input) do
    input
    |> parse()
    |> run()
    |> Map.fetch!(:output)
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join(",")
  end

  @doc """
  Part 2

  Program: 2,4,1,1,7,5,1,5,4,0,0,3,5,5,3,0

   0: bst 4 (b = rem(a, 8))
   2: bxl 1 (b = b xor 1)
   4: cdv 5 (c = div(a, 2^B))
   6: bxl 5 (b = b xor 5)
   8: bxc 0 (b = b xor c)
  10: adv 3 (a = div(a, 8))
  12: out 5 (output rem(b, 8))
  14: jnz 0 (if a != 0 goto 0)

  Pseudo code:

      a = n
      out = []

      do
        # Lowest 3 bits of a
        b = rem(a, 8)

        # Magic calculations including other (larger) bits of a
        b = b xor 1
        c = div(a, 2^b)
        b = b xor 5
        b = b xor c

        out += rem(b, 8)

        # Truncate a by 3 bits
        a = div(a, 8)
      end
      while a != 0

  Each iteration we look at 3 bits of a and then truncate those three bits.

  We can search for a 3 bits at a time.
  We need to search from the most significant bits first, since the output is
  also dependend on more significant bits of a.
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    runtime = parse(input)

    desired_output = runtime.program |> Enum.sort() |> Enum.map(&elem(&1, 1))
    a = find_a(runtime, 0, Enum.reverse(desired_output))

    # Check that it is correct
    runtime = run(%{runtime | regs: %{runtime.regs | a: a}})
    output = runtime.output
    ^desired_output = output

    a
  end

  defp find_a(_runtime, a, []), do: a

  defp find_a(runtime, a, [next | rest]) do
    0..7
    |> Enum.filter(fn bits ->
      runtime = run(%{runtime | regs: %{runtime.regs | a: a * 8 + bits}})
      runtime.output |> hd() == next
    end)
    |> Enum.map(fn bits -> find_a(runtime, a * 8 + bits, rest) end)
    |> Enum.filter(&is_integer/1)
    |> case do
      [] -> :error
      # If there are multiple solutions, we just pick the first one
      [a | _] -> a
    end
  end

  defp run(runtime) do
    case Map.fetch(runtime.program, runtime.op_pointer) do
      {:ok, opcode} ->
        {instruction, operand_type} = instruction(opcode)
        operand = read_operand(runtime, operand_type)
        runtime = apply_opcode(runtime, instruction, operand)
        runtime = %{runtime | op_pointer: runtime.op_pointer + 2}
        run(runtime)

      :error ->
        %{runtime | output: Enum.reverse(runtime.output)}
    end
  end

  defp apply_opcode(runtime, :adv, operand) do
    numerator = runtime.regs.a
    denominator = Integer.pow(2, operand)
    result = div(numerator, denominator)
    %{runtime | regs: %{runtime.regs | a: result}}
  end

  defp apply_opcode(runtime, :cdv, operand) do
    numerator = runtime.regs.a
    denominator = Integer.pow(2, operand)
    result = div(numerator, denominator)
    %{runtime | regs: %{runtime.regs | c: result}}
  end

  defp apply_opcode(runtime, :bst, operand) do
    result = rem(operand, 8)
    %{runtime | regs: %{runtime.regs | b: result}}
  end

  defp apply_opcode(runtime, :out, operand) do
    # Note that this prepends the output. When the programs halts we reverse it.
    result = rem(operand, 8)
    %{runtime | output: [result | runtime.output]}
  end

  defp apply_opcode(runtime, :jnz, operand) do
    if runtime.regs.a == 0 do
      runtime
    else
      %{runtime | op_pointer: operand - 2}
    end
  end

  defp apply_opcode(runtime, :bxc, _operand) do
    result = Bitwise.bxor(runtime.regs.b, runtime.regs.c)
    %{runtime | regs: %{runtime.regs | b: result}}
  end

  defp apply_opcode(runtime, :bxl, operand) do
    result = Bitwise.bxor(runtime.regs.b, operand)
    %{runtime | regs: %{runtime.regs | b: result}}
  end

  defp instruction(0), do: {:adv, :combo}
  defp instruction(1), do: {:bxl, :literal}
  defp instruction(2), do: {:bst, :combo}
  defp instruction(3), do: {:jnz, :literal}
  defp instruction(4), do: {:bxc, :ignore}
  defp instruction(5), do: {:out, :combo}
  defp instruction(6), do: {:bdv, :combo}
  defp instruction(7), do: {:cdv, :combo}

  defp read_operand(runtime, operand_type) do
    operand = Map.fetch!(runtime.program, runtime.op_pointer + 1)

    case {operand_type, operand} do
      {:combo, n} when n <= 3 -> n
      {:combo, 4} -> runtime.regs.a
      {:combo, 5} -> runtime.regs.b
      {:combo, 6} -> runtime.regs.c
      {:literal, n} -> n
      {:ignore, _} -> 0
    end
  end

  defp parse(input) do
    {regs, program} =
      input
      |> String.trim()
      |> String.split("\n\n", trim: true)
      |> then(fn [registers_input, program_input] ->
        registers =
          registers_input
          |> String.split("\n", trim: true)
          |> Enum.map(fn line ->
            [_, value] = String.split(line, ": ")
            String.to_integer(value)
          end)

        program =
          program_input
          |> String.split(": ", trim: true)
          |> then(fn [_, ops] -> ops end)
          |> String.split(",", trim: true)
          |> Enum.map(&String.to_integer/1)

        {registers, program}
      end)

    regs =
      [:a, :b, :c]
      |> Enum.zip(regs)
      |> Enum.into(%{})

    program =
      program
      |> Enum.with_index()
      |> Enum.into(%{}, fn {op, i} -> {i, op} end)

    output = []

    op_pointer = 0

    %{
      regs: regs,
      program: program,
      output: output,
      op_pointer: op_pointer
    }
  end
end
