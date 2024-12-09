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

  Runs in around 1 second on my machine
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    filesystem = input |> parse()
    files_rev = filesystem |> Enum.filter(&match?({:file, _, _}, &1)) |> Enum.reverse()

    processed = MapSet.new()

    checksum_2(filesystem, files_rev, 0, 0, processed)
  end

  # Terminating condition
  defp checksum_2([], _, _, sum, _), do: sum

  # When we reach an unprocessed file, we just add it and skip to the next
  # thing in the filesystem
  defp checksum_2([{:file, length, id} | filesystem], files_rev, index, sum, processed) do
    if MapSet.member?(processed, id) do
      checksum_2(filesystem, files_rev, index + length, sum, processed)
    else
      checksum_2(
        filesystem,
        files_rev,
        index + length,
        sum + part_checksum(index, length, id),
        MapSet.put(processed, id)
      )
    end
  end

  # We reached free space. Find the right most file that fits in the free space
  defp checksum_2([{:free, free_length} | filesystem], files_rev, index, sum, processed) do
    file =
      Enum.find(files_rev, fn {:file, file_length, id} ->
        file_length <= free_length and not MapSet.member?(processed, id)
      end)

    case file do
      nil ->
        checksum_2(filesystem, files_rev, index + free_length, sum, processed)

      {:file, file_length, id} ->
        checksum_2(
          insert({:free, free_length - file_length}, filesystem),
          files_rev,
          index + file_length,
          sum + part_checksum(index, file_length, id),
          MapSet.put(processed, id)
        )
    end
  end

  # Calculate checksum for a file in constant time
  # This is just the formula for adding consecutive numbers being used and then
  # simplified the final expression
  defp part_checksum(index, length, id) do
    id * div(length * (2 * index + length - 1), 2)
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
