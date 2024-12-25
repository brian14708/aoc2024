import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import gleam/string_tree

fn calc(
  vars: dict.Dict(String, Int),
  eqs: dict.Dict(String, #(String, String, String)),
  k: String,
) -> Result(dict.Dict(String, Int), Nil) {
  use <- bool.lazy_guard(dict.has_key(vars, k), fn() { Ok(vars) })
  use v <- result.try(dict.get(eqs, k))
  let #(op, x, y) = v

  use vars <- result.try(
    calc(vars, eqs, x) |> result.then(fn(vars) { calc(vars, eqs, y) }),
  )
  let assert Ok(x) = dict.get(vars, x)
  let assert Ok(y) = dict.get(vars, y)

  dict.insert(vars, k, case op {
    "AND" -> int.bitwise_and(x, y)
    "OR" -> int.bitwise_or(x, y)
    "XOR" -> int.bitwise_exclusive_or(x, y)
    _ -> -1
  })
  |> Ok
}

fn parse(s: String) {
  let assert [vars, eqs] = s |> string.split("\n\n")
  let vars =
    vars
    |> string.split("\n")
    |> list.map(fn(l) {
      let assert [k, v] = l |> string.split(": ")
      #(k, v |> int.parse |> result.unwrap(0))
    })
    |> dict.from_list
  let eqs =
    eqs
    |> string.split("\n")
    |> list.map(fn(l) {
      let assert [x, op, y, _, z] = l |> string.split(" ")
      #(z, #(op, x, y))
    })
    |> dict.from_list
  #(vars, eqs)
}

pub fn part1(s: String) -> Result(String, String) {
  let #(vars, eqs) = s |> parse

  eqs
  |> dict.keys
  |> list.try_fold(vars, fn(vars, k) { calc(vars, eqs, k) })
  |> result.lazy_unwrap(dict.new)
  |> dict.to_list
  |> list.sort(fn(a, b) { string.compare(a.0, b.0) })
  |> list.filter(fn(v) { string.starts_with(v.0, "z") })
  |> list.map(fn(v) { v.1 })
  |> list.reverse
  |> list.fold(0, fn(acc, v) {
    int.bitwise_or(int.bitwise_shift_left(acc, 1), v)
  })
  |> int.to_string
  |> Ok
}

pub fn part2(s: String) -> Result(String, String) {
  let #(vars, eqs) = s |> parse

  eqs
  |> dict.to_list
  |> list.fold(string_tree.from_string("digraph {\n"), fn(st, v) {
    let #(out, #(op, x, y)) = v
    st
    |> string_tree.append(out)
    |> string_tree.append(" [style=filled,color=")
    |> string_tree.append(case op {
      "AND" -> "red"
      "OR" -> "blue"
      "XOR" -> "green"
      _ -> "UNKNOWN"
    })
    |> string_tree.append("];\n")
    |> string_tree.append(x)
    |> string_tree.append(" -> ")
    |> string_tree.append(out)
    |> string_tree.append(";\n")
    |> string_tree.append(y)
    |> string_tree.append(" -> ")
    |> string_tree.append(out)
    |> string_tree.append(";\n")
  })
  |> fn(st) {
    list.fold(vars |> dict.keys, st, fn(st, v) {
      case string.starts_with(v, "x") {
        True -> st
        False -> {
          let id = v |> string.slice(1, string.length(v))
          st
          |> string_tree.append("subgraph cluster_")
          |> string_tree.append(id)
          |> string_tree.append("{\n")
          |> string_tree.append("x" <> id <> "\n")
          |> string_tree.append("y" <> id <> "\n")
          |> string_tree.append("z" <> id <> "\n")
          |> string_tree.append("}\n")
        }
      }
    })
  }
  |> string_tree.append("}\n")
  |> string_tree.to_string
  |> Ok
}
