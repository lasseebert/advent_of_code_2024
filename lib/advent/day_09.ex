defmodule Advent.Day09 do
  @moduledoc """
  Day 09
  """

  @doc """
  Part 1

  Algorithm is:

  Have two pointers:

  * One from the start of the filesystem going forward
  * One from the end of the filesystem going backwards

  When the first pointer is on free space, move file chunk from the last pointer.
  The files are not actually moved in the data structure, just counted towards the checksum.

  This runs in linear time of the size of the filesystem.
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    filesystem = input |> parse()
    filesystem_rev = Enum.reverse(filesystem)

    calc_checksum(0, 0, filesystem, filesystem_rev)
  end

  # When we reach this, the two pointers have reach each other, so we just add
  # the last chunks of the file to the sum
  defp calc_checksum(index, sum, [{:file, _, id} | _filesystem], [{:file, length, id} | _filesystem_rev]) do
    1..length
    |> Enum.with_index()
    |> Enum.reduce(sum, fn {_, delta}, sum -> sum + (index + delta) * id end)
  end

  # There is already a file
  defp calc_checksum(index, sum, [{:file, length, id} | filesystem], filesystem_rev) do
    calc_checksum(index + 1, sum + index * id, insert({:file, length - 1, id}, filesystem), filesystem_rev)
  end

  # Skip free space in last pointer
  defp calc_checksum(index, sum, filesystem, [{:free, _} | filesystem_rev]) do
    calc_checksum(index, sum, filesystem, filesystem_rev)
  end

  # Fragmentation case
  defp calc_checksum(index, sum, [{:free, free_length} | filesystem], [{:file, file_length, id} | filesystem_rev]) do
    calc_checksum(
      index + 1,
      sum + index * id,
      insert({:free, free_length - 1}, filesystem),
      insert({:file, file_length - 1, id}, filesystem_rev)
    )
  end

  # Reinsert file or free space into file system. If they are size 0, they are removed
  defp insert({:file, 0, _id}, filesystem), do: filesystem
  defp insert({:free, 0}, filesystem), do: filesystem
  defp insert(item, filesystem), do: [item | filesystem]

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
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.reject(fn {length, _index} -> length == 0 end)
    |> Enum.map(fn {length, index} ->
      if rem(index, 2) == 0 do
        {:file, length, div(index, 2)}
      else
        {:free, length}
      end
    end)
  end
end
