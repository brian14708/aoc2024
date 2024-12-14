import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result
import gleam/set
import gleam/string
import gleam/string_tree

fn parse_line(l: String) {
  let assert Ok(re) = regexp.from_string("-?[0-9]+")
  case regexp.scan(re, l) {
    [px, py, vx, vy] -> {
      use px <- result.try(int.parse(px.content))
      use py <- result.try(int.parse(py.content))
      use vx <- result.try(int.parse(vx.content))
      use vy <- result.try(int.parse(vy.content))
      Ok(#(px, py, vx, vy))
    }
    _ -> Error(Nil)
  }
}

fn move(pos: #(Int, Int, Int, Int), width: Int, height: Int, steps: Int) {
  let #(px, py, vx, vy) = pos
  let px = { px + vx * steps } % width
  let py = { py + vy * steps } % height
  #(
    case px < 0 {
      True -> width + px
      False -> px
    },
    case py < 0 {
      True -> height + py
      False -> py
    },
  )
}

fn quad(pos: #(Int, Int), width: Int, height: Int) {
  let #(x, y) = pos
  let w = { width - 1 } / 2
  let h = { height - 1 } / 2
  case x < w, x > w, y < h, y > h {
    True, False, True, False -> Ok(0)
    False, True, True, False -> Ok(1)
    True, False, False, True -> Ok(2)
    False, True, False, True -> Ok(3)
    _, _, _, _ -> Error(Nil)
  }
}

pub fn part1_impl(s: String, width: Int, height: Int) -> Result(String, String) {
  use lines <- result.try(
    s
    |> string.split("\n")
    |> list.try_map(parse_line)
    |> result.replace_error("parse error"),
  )

  lines
  |> list.map(fn(n) { move(n, width, height, 100) })
  |> list.filter_map(fn(n) { quad(n, width, height) })
  |> list.fold(dict.new(), fn(n, d) {
    dict.upsert(n, d, fn(x) {
      case x {
        option.Some(x) -> 1 + x
        option.None -> 1
      }
    })
  })
  |> dict.values
  |> int.product
  |> int.to_string
  |> Ok
}

pub fn part1(s: String) -> Result(String, String) {
  part1_impl(s, 101, 103)
}

fn print(d: List(#(Int, Int)), width: Int, height: Int) {
  list.range(0, height - 1)
  |> list.fold(string_tree.new(), fn(st, y) {
    list.range(0, width - 1)
    |> list.fold(st, fn(st, x) {
      string_tree.append(st, case list.count(d, fn(n) { n == #(x, y) }) {
        0 -> "."
        _ -> "#"
      })
    })
    |> string_tree.append("\n")
  })
  |> string_tree.to_string
}

fn neigh(s: List(#(Int, Int))) {
  let st = set.from_list(s)
  s
  |> list.count(fn(p) {
    let #(x, y) = p
    [
      #(x - 1, y - 1),
      #(x, y - 1),
      #(x + 1, y - 1),
      #(x - 1, y),
      #(x + 1, y),
      #(x - 1, y + 1),
      #(x, y + 1),
      #(x + 1, y + 1),
    ]
    |> list.find(fn(p) { set.contains(st, p) })
    |> result.is_ok
  })
}

pub fn part2(s: String) -> Result(String, String) {
  let width = 101
  let height = 103
  use lines <- result.try(
    s
    |> string.split("\n")
    |> list.try_map(parse_line)
    |> result.replace_error("parse error"),
  )

  list.range(0, 100_000)
  |> list.find(fn(i) {
    let q =
      lines
      |> list.map(fn(n) { move(n, width, height, i) })

    neigh(q) > list.length(q) * 2 / 3
  })
  |> result.map(fn(i) {
    let q =
      lines
      |> list.map(fn(n) { move(n, width, height, i) })
      |> print(width, height)

    q <> "\n" <> int.to_string(i)
  })
  |> result.replace_error("no solution")
}
