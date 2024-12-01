import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string

fn parse(s: String) {
  s
  |> string.split("\n")
  |> list.try_map(fn(line) {
    line
    |> string.split_once(" ")
    |> result.then(fn(s) {
      use a <- result.try(s.0 |> int.parse)
      use b <- result.try(s.1 |> string.trim |> int.parse)
      Ok(#(a, b))
    })
  })
  |> result.replace_error("Failed to parse input")
}

pub fn part1(s: String) {
  use ints <- result.try(parse(s))
  let #(first, second) = list.unzip(ints)
  list.zip(first |> list.sort(int.compare), second |> list.sort(int.compare))
  |> list.map(fn(a) { int.absolute_value(a.1 - a.0) })
  |> int.sum
  |> int.to_string
  |> Ok
}

pub fn part2(s: String) {
  use ints <- result.try(parse(s))
  let #(first, second) = ints |> list.unzip
  let counter =
    list.fold(second, dict.new(), fn(counter, x) {
      dict.upsert(counter, x, fn(y) {
        case y {
          option.Some(v) -> v + 1
          option.None -> 1
        }
      })
    })
  list.fold(first, 0, fn(sum, x) {
    let freq = dict.get(counter, x) |> result.unwrap(0)
    sum + freq * x
  })
  |> int.to_string
  |> Ok
}
