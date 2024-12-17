defmodule Advent.Day17 do
  @moduledoc """
  Day 17
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: String.t()
  def part_1(input) do
    {regs, program} = input |> parse()

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

    runtime = %{
      regs: regs,
      program: program,
      output: output,
      op_pointer: op_pointer
    }

    runtime
    |> run()
    |> Map.fetch!(:output)
    |> Enum.reverse()
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join(",")
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
        runtime
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

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()

    0
  end

  defp parse(input) do
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
  end
end
