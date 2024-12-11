import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn memoize(
  cache: dict.Dict(#(Int, Int), Int),
  key: #(Int, Int),
  f: fn() -> #(Int, dict.Dict(#(Int, Int), Int)),
) {
  case dict.get(cache, key) {
    Ok(v) -> #(v, cache)
    Error(_) -> {
      let #(v, cache) = f()
      #(v, dict.insert(cache, key, v))
    }
  }
}

fn count(n: Int, layer: Int, cache: dict.Dict(#(Int, Int), Int)) {
  use <- bool.guard(layer == 0, #(1, cache))
  case n {
    0 -> count(1, layer - 1, cache)
    val -> {
      use <- memoize(cache, #(n, layer))
      let d = int.digits(val, 10) |> result.unwrap([])
      let #(before, after) = list.split(d, list.length(d) / 2)
      case list.length(before) == list.length(after) {
        True -> {
          let a = list.fold(after, 0, fn(acc, x) { acc * 10 + x })
          let b = list.fold(before, 0, fn(acc, x) { acc * 10 + x })
          let #(va, cache) = count(a, layer - 1, cache)
          let #(vb, cache) = count(b, layer - 1, cache)
          #(va + vb, cache)
        }
        False -> count(val * 2024, layer - 1, cache)
      }
    }
  }
}

pub fn part1(s: String) -> Result(String, String) {
  use d <- result.try(
    s
    |> string.split(" ")
    |> list.try_map(int.parse)
    |> result.replace_error("parse error"),
  )
  let #(n, _) =
    d
    |> list.fold(#(0, dict.new()), fn(acc, data) {
      let #(n, cache) = acc
      let #(v, cache) = count(data, 25, cache)
      #(n + v, cache)
    })
  n
  |> int.to_string
  |> Ok
}

pub fn part2(s: String) -> Result(String, String) {
  use d <- result.try(
    s
    |> string.split(" ")
    |> list.try_map(int.parse)
    |> result.replace_error("parse error"),
  )
  let #(n, _) =
    d
    |> list.fold(#(0, dict.new()), fn(acc, data) {
      let #(n, cache) = acc
      let #(v, cache) = count(data, 75, cache)
      #(n + v, cache)
    })
  n
  |> int.to_string
  |> Ok
}
