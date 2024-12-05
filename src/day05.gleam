import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/order
import gleam/result
import gleam/set
import gleam/string

fn list_to_tuple2(l: List(v)) -> Result(#(v, v), Nil) {
  case l {
    [a, b] -> Ok(#(a, b))
    _ -> Error(Nil)
  }
}

fn parse(s: String) -> Result(#(List(#(Int, Int)), List(List(Int))), Nil) {
  use #(head, tail) <- result.try(s |> string.split("\n\n") |> list_to_tuple2)
  use m <- result.try(
    head
    |> string.split("\n")
    |> list.try_map(fn(line) {
      use p <- result.try(string.split(line, "|") |> list.try_map(int.parse))
      list_to_tuple2(p)
    }),
  )
  use l <- result.try(
    tail
    |> string.split("\n")
    |> list.try_map(fn(line) {
      string.split(line, ",") |> list.try_map(int.parse)
    }),
  )
  Ok(#(m, l))
}

type Graph =
  dict.Dict(Int, set.Set(Int))

fn flatten(l: List(#(Int, Int))) -> Graph {
  list.fold(l, dict.new(), fn(acc, edge) {
    let #(a, b) = edge
    dict.upsert(acc, a, fn(e) {
      case e {
        option.None -> set.from_list([b])
        option.Some(s) -> set.insert(s, b)
      }
    })
  })
}

fn is_correct(order: Graph, vals: List(Int)) -> Bool {
  list.index_fold(vals, True, fn(acc, i, idx) {
    acc
    && list.all(list.drop(vals, idx + 1), fn(j) {
      dict.get(order, i)
      |> result.then(fn(s) {
        case set.contains(s, j) {
          True -> Ok(Nil)
          False -> Error(Nil)
        }
      })
      |> result.is_ok
    })
  })
}

pub fn part1(s: String) {
  use r <- result.try(parse(s) |> result.replace_error("parse error"))
  let graph = flatten(r.0)
  r.1
  |> list.filter(fn(l) { is_correct(graph, l) })
  |> list.try_map(fn(l) {
    // middle element
    l |> list.drop(list.length(l) / 2) |> list.first
  })
  |> result.map(fn(l) { l |> int.sum |> int.to_string })
  |> result.replace_error("element not found")
}

fn fix(order: Graph, vals: List(Int)) -> List(Int) {
  list.sort(vals, fn(a, b) {
    dict.get(order, a)
    |> result.then(fn(s) {
      case set.contains(s, b) {
        True -> Ok(order.Gt)
        False -> Ok(order.Lt)
      }
    })
    |> result.unwrap(order.Lt)
  })
}

pub fn part2(s: String) {
  use r <- result.try(parse(s) |> result.replace_error("parse error"))
  let graph = flatten(r.0)
  r.1
  |> list.filter(fn(l) { !is_correct(graph, l) })
  |> list.map(fn(l) { fix(graph, l) })
  |> list.try_map(fn(l) {
    // middle element
    l |> list.drop(list.length(l) / 2) |> list.first
  })
  |> result.map(fn(l) { l |> int.sum |> int.to_string })
  |> result.replace_error("element not found")
}
