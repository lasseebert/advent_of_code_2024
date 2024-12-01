# Advent

Me solving [Advent of Code 2024](https://adventofcode.com/2024) in Elixir.

## Running the thing

To run all puzzle inputs (real inputs) and print a list of the slowest do:

```
mix test --slowest 10 --only puzzle_input
```

## Solving puzzles

To generate templates for a new day of puzzles, e.g. day 4, run:

```
mix advent.gen.day 04
```

## Starting another year

To make a new project for another year, e.g. 2025, here's a check list:

* Copy the dir to the new year
* Remove the .git dir
* Init git
* Remove the lib/advent, test/advent, puzzle_inputs and puzzle_texts dirs
* Search and replace the year e.g. 2024 -> 2025
* Install latest elixir
* Update dependecies
