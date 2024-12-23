import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/set
import gleam/string

fn parse(s: String) -> dict.Dict(String, set.Set(String)) {
  s
  |> string.split("\n")
  |> list.map(fn(l) { string.split(l, "-") })
  |> list.fold(dict.new(), fn(d, p) {
    let assert [a, b] = p
    d
    |> dict.upsert(a, fn(v) { option.lazy_unwrap(v, set.new) |> set.insert(b) })
    |> dict.upsert(b, fn(v) { option.lazy_unwrap(v, set.new) |> set.insert(a) })
  })
}

fn neigh(
  graph: dict.Dict(String, set.Set(String)),
  k: String,
) -> set.Set(String) {
  dict.get(graph, k) |> result.lazy_unwrap(set.new)
}

pub fn part1(s: String) -> Result(String, String) {
  let graph = parse(s)
  graph
  |> dict.keys
  |> list.filter(fn(k) { string.starts_with(k, "t") })
  |> list.flat_map(fn(k) {
    neigh(graph, k)
    |> set.to_list
    |> list.flat_map(fn(n) {
      neigh(graph, n)
      |> set.to_list
      |> list.filter_map(fn(m) {
        case set.contains(neigh(graph, m), k) {
          True -> Ok([m, n, k] |> list.sort(string.compare))
          False -> Error(Nil)
        }
      })
    })
  })
  |> list.unique
  |> list.length
  |> int.to_string
  |> Ok
}

pub fn part2(s: String) -> Result(String, String) {
  let graph = parse(s)
  bron_kerbosch(
    graph,
    set.new(),
    dict.keys(graph) |> set.from_list,
    set.new(),
    list.new(),
  )
  |> list.sort(fn(a, b) { int.compare(set.size(a), set.size(b)) })
  |> list.last
  |> result.lazy_unwrap(set.new)
  |> set.to_list
  |> list.sort(string.compare)
  |> string.join(",")
  |> Ok
}

fn bron_kerbosch(
  graph: dict.Dict(String, set.Set(String)),
  r: set.Set(String),
  p: set.Set(String),
  x: set.Set(String),
  accum: List(set.Set(String)),
) -> List(set.Set(String)) {
  use <- bool.lazy_guard(set.is_empty(p) && set.is_empty(x), fn() {
    accum |> list.append([r])
  })
  p
  |> set.difference(
    // pivot_neigh
    set.union(p, x)
    |> set.fold(set.new(), fn(acc, v) {
      let neigh = neigh(graph, v)
      case set.size(neigh) > set.size(acc) {
        True -> neigh
        False -> acc
      }
    }),
  )
  |> set.fold(#(accum, p, x), fn(acc, v) {
    let #(accum, p, x) = acc
    let neigh = neigh(graph, v)
    #(
      bron_kerbosch(
        graph,
        set.insert(r, v),
        set.intersection(p, neigh),
        set.intersection(x, neigh),
        accum,
      ),
      set.delete(p, v),
      set.insert(x, v),
    )
  })
  |> fn(x) { x.0 }
}
