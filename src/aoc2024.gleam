import argv
import gleam/dict
import gleam/io
import gleam/result
import gleam/string
import simplifile

import day01
import day02

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
