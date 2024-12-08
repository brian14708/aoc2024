import argv
import gleam/dict
import gleam/io
import gleam/result
import gleam/string
import simplifile

import day01
import day02
import day03
import day04
import day05
import day06
import day07
import day08
import day09
import day10
import day11
import day12
import day13
import day14
import day15
import day16
import day17
import day18
import day19
import day20
import day21
import day22
import day23
import day24
import day25

pub type Error {
  ReadFileError(simplifile.FileError)
  ProgramError(String)
  InvalidArguments
}

pub fn main() -> Result(Nil, Error) {
  let solutions =
    dict.from_list([
      #("day01_part1", day01.part1),
      #("day01_part2", day01.part2),
      #("day02_part1", day02.part1),
      #("day02_part2", day02.part2),
      #("day03_part1", day03.part1),
      #("day03_part2", day03.part2),
      #("day04_part1", day04.part1),
      #("day04_part2", day04.part2),
      #("day05_part1", day05.part1),
      #("day05_part2", day05.part2),
      #("day06_part1", day06.part1),
      #("day06_part2", day06.part2),
      #("day07_part1", day07.part1),
      #("day07_part2", day07.part2),
      #("day08_part1", day08.part1),
      #("day08_part2", day08.part2),
      #("day09_part1", day09.part1),
      #("day09_part2", day09.part2),
      #("day10_part1", day10.part1),
      #("day10_part2", day10.part2),
      #("day11_part1", day11.part1),
      #("day11_part2", day11.part2),
      #("day12_part1", day12.part1),
      #("day12_part2", day12.part2),
      #("day13_part1", day13.part1),
      #("day13_part2", day13.part2),
      #("day14_part1", day14.part1),
      #("day14_part2", day14.part2),
      #("day15_part1", day15.part1),
      #("day15_part2", day15.part2),
      #("day16_part1", day16.part1),
      #("day16_part2", day16.part2),
      #("day17_part1", day17.part1),
      #("day17_part2", day17.part2),
      #("day18_part1", day18.part1),
      #("day18_part2", day18.part2),
      #("day19_part1", day19.part1),
      #("day19_part2", day19.part2),
      #("day20_part1", day20.part1),
      #("day20_part2", day20.part2),
      #("day21_part1", day21.part1),
      #("day21_part2", day21.part2),
      #("day22_part1", day22.part1),
      #("day22_part2", day22.part2),
      #("day23_part1", day23.part1),
      #("day23_part2", day23.part2),
      #("day24_part1", day24.part1),
      #("day24_part2", day24.part2),
      #("day25_part1", day25.part1),
      #("day25_part2", day25.part2),
    ])

  case argv.load().arguments {
    [day, part, filepath] -> {
      let key = day <> "_" <> part
      case dict.get(solutions, key) {
        Ok(solution) -> {
          filepath
          |> simplifile.read
          |> result.map_error(ReadFileError)
          |> result.then(fn(x) {
            solution(string.trim(x)) |> result.map_error(ProgramError)
          })
          |> result.map(io.println)
          |> result.map_error(io.debug)
        }
        Error(_) -> {
          io.println("Unknown day or part")
          Error(InvalidArguments)
        }
      }
    }
    _ -> {
      io.println("Usage: aoc2024 [day] [part] [filepath]")
      Error(InvalidArguments)
    }
  }
}
