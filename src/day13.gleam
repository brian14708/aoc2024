import gleam/int
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string

fn parse_sec(l: String) {
  let assert Ok(re) = regexp.from_string("[0-9]+")
  case regexp.scan(re, l) {
    [a, b] -> {
      #(
        int.parse(a.content) |> result.unwrap(0),
        int.parse(b.content) |> result.unwrap(0),
      )
    }
    _ -> #(0, 0)
  }
}

fn parse(s: String) {
  s
  |> string.split("\n")
  |> list.sized_chunk(4)
  |> list.map(fn(s) {
    case s {
      [l1, l2, l3] -> #(parse_sec(l1), parse_sec(l2), parse_sec(l3))
      [l1, l2, l3, _] -> #(parse_sec(l1), parse_sec(l2), parse_sec(l3))
      _ -> #(#(0, 0), #(0, 0), #(0, 0))
    }
  })
}

fn solve(s: List(#(#(Int, Int), #(Int, Int), #(Int, Int)))) {
  s
  |> list.filter_map(fn(s) {
    let x = s.2.0 * s.0.1 - s.2.1 * s.0.0
    let y = s.0.1 * s.1.0 - s.1.1 * s.0.0
    case x % y == 0 {
      True -> Ok(#({ s.2.0 * y - x * s.1.0 } / { y * s.0.0 }, x / y))
      False -> Error(Nil)
    }
  })
  |> list.filter(fn(s) { s.0 >= 0 && s.1 >= 0 })
}

pub fn part1(s: String) -> Result(String, String) {
  s
  |> parse
  |> solve
  |> list.map(fn(s) { { s.0 * 3 } + s.1 })
  |> int.sum
  |> int.to_string
  |> Ok
}

pub fn part2(s: String) -> Result(String, String) {
  s
  |> parse
  |> list.map(fn(s) {
    #(s.0, s.1, #(s.2.0 + 10_000_000_000_000, s.2.1 + 10_000_000_000_000))
  })
  |> solve
  |> list.map(fn(s) { { s.0 * 3 } + s.1 })
  |> int.sum
  |> int.to_string
  |> Ok
}
