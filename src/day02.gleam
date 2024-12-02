import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn parse(s: String) {
  s
  |> string.split("\n")
  |> list.try_map(fn(line) {
    line
    |> string.split(" ")
    |> list.try_map(int.parse)
  })
  |> result.replace_error("Failed to parse input")
}

fn is_safe(n: List(Int)) {
  let #(min, max) =
    list.fold(list.window_by_2(n), #(100_000, -100_000), fn(acc, n) {
      #(int.min(acc.0, n.1 - n.0), int.max(acc.1, n.1 - n.0))
    })

  min * max > 0
  && int.absolute_value(min) >= 1
  && int.absolute_value(min) <= 3
  && int.absolute_value(max) >= 1
  && int.absolute_value(max) <= 3
}

fn is_safe2(n: List(Int)) {
  use <- bool.guard(when: is_safe(n), return: True)

  let with_idx = list.index_map(n, fn(a, i) { #(a, i) })
  use el <- list.any(with_idx)

  with_idx
  |> list.filter_map(fn(e) {
    case e != el {
      True -> Ok(e.0)
      False -> Error(Nil)
    }
  })
  |> is_safe
}

pub fn part1(s: String) {
  use input <- result.try(parse(s))
  list.fold(input, 0, fn(acc, s) {
    case is_safe(s) {
      True -> acc + 1
      False -> acc
    }
  })
  |> int.to_string
  |> Ok
}

pub fn part2(s: String) {
  use input <- result.try(parse(s))
  list.fold(input, 0, fn(acc, s) {
    case is_safe2(s) {
      True -> acc + 1
      False -> acc
    }
  })
  |> int.to_string
  |> Ok
}
