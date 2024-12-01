import argv
import gleam/dict
import gleam/io
import gleam/result
import simplifile

import day01

pub type Error {
  ReadFileError(simplifile.FileError)
  InvalidArguments
}

pub fn main() -> Result(Nil, Error) {
  let solutions = dict.from_list([#("day01_part1", day01.part1)])

  case argv.load().arguments {
    [day, part, filepath] -> {
      let key = day <> "_" <> part
      case dict.get(solutions, key) {
        Ok(solution) -> {
          filepath
          |> simplifile.read
          |> result.map_error(ReadFileError)
          |> result.map(solution)
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
