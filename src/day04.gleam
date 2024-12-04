import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string

fn build_index(
  s: String,
) -> #(dict.Dict(#(Int, Int), String), dict.Dict(String, List(#(Int, Int)))) {
  string.split(s, "\n")
  |> list.index_fold(#(dict.new(), dict.new()), fn(acc, line, i) {
    let chars = line |> string.split("")
    #(
      list.index_fold(chars, acc.0, fn(index, c, j) {
        dict.insert(index, #(j, i), c)
      }),
      list.index_fold(chars, acc.1, fn(inverted, c, j) {
        dict.upsert(inverted, c, fn(x) {
          case x {
            option.Some(x) -> list.append(x, [#(j, i)])
            option.None -> [#(j, i)]
          }
        })
      }),
    )
  })
}

const directions = [
  #(0, 1), #(0, -1), #(1, 0), #(-1, 0), #(1, 1), #(1, -1), #(-1, 1), #(-1, -1),
]

fn find_word(
  index: dict.Dict(#(Int, Int), String),
  inverted: dict.Dict(String, List(#(Int, Int))),
  word: String,
) -> Result(Int, Nil) {
  let assert Ok(h) = string.first(word)
  let chars = word |> string.split("")
  use start <- result.map(dict.get(inverted, h))
  list.fold(start, 0, fn(s, pos) {
    s
    + list.count(directions, fn(dir) {
      list.index_fold(chars, True, fn(prev, c, i) {
        prev
        && Ok(c) == dict.get(index, #(pos.0 + i * dir.0, pos.1 + i * dir.1))
      })
    })
  })
}

fn find_x(
  index: dict.Dict(#(Int, Int), String),
  inverted: dict.Dict(String, List(#(Int, Int))),
  word: String,
) -> Result(Int, Nil) {
  let radius = string.length(word) / 2
  let center = string.slice(word, radius, 1)
  use start <- result.map(dict.get(inverted, center))
  let match = fn(s: String) { s == word || string.reverse(s) == word }
  list.fold(start, 0, fn(s, pos) {
    let #(i, j) = pos
    let diag1 =
      list.range(-radius, radius)
      |> list.map(fn(x) { result.unwrap(dict.get(index, #(i + x, j + x)), "") })
      |> string.join("")
      |> match
    let diag2 =
      list.range(-radius, radius)
      |> list.map(fn(x) { result.unwrap(dict.get(index, #(i - x, j + x)), "") })
      |> string.join("")
      |> match
    case diag1 && diag2 {
      True -> s + 1
      False -> s
    }
  })
}

pub fn part1(s: String) {
  let #(index, inverted) = build_index(s)
  find_word(index, inverted, "XMAS")
  |> result.unwrap(0)
  |> int.to_string
  |> Ok
}

pub fn part2(s: String) {
  let #(index, inverted) = build_index(s)
  find_x(index, inverted, "MAS")
  |> result.unwrap(0)
  |> int.to_string
  |> Ok
}
