import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import gleamy/priority_queue as pq

type Graph {
  Graph(
    edges: dict.Dict(String, List(#(String, String))),
    paths: dict.Dict(#(String, String), List(String)),
  )
}

fn bfs_loop(
  graph: dict.Dict(String, List(#(String, String))),
  q: pq.Queue(#(String, String, Int)),
  end: String,
  result: List(String),
) -> List(String) {
  use <- bool.guard(pq.is_empty(q), result)
  let assert Ok(#(#(action, node, cost), q)) = pq.pop(q)
  let prev_cost =
    result |> list.first |> result.map(string.length) |> result.unwrap(999)
  use <- bool.guard(cost > prev_cost, result)
  use <- bool.lazy_guard(node == end, fn() {
    bfs_loop(graph, q, end, result |> list.append([action <> "A"]))
  })

  let q =
    dict.get(graph, node)
    |> result.unwrap([])
    |> list.fold(q, fn(acc, n) { pq.push(acc, #(action <> n.0, n.1, cost + 1)) })
  bfs_loop(graph, q, end, result)
}

const keypad = [
  #("7", [#(">", "8"), #("v", "5")]),
  #("8", [#("<", "7"), #(">", "9"), #("v", "5")]),
  #("9", [#("<", "8"), #("v", "6")]),
  #("4", [#(">", "5"), #("v", "1"), #("^", "7")]),
  #("5", [#("<", "4"), #(">", "6"), #("v", "2"), #("^", "8")]),
  #("6", [#("<", "5"), #("v", "3"), #("^", "9")]),
  #("1", [#(">", "2"), #("^", "4")]),
  #("2", [#("<", "1"), #(">", "3"), #("^", "5"), #("v", "0")]),
  #("3", [#("<", "2"), #("^", "6"), #("v", "A")]),
  #("0", [#("^", "2"), #(">", "A")]), #("A", [#("^", "3"), #("<", "0")]),
]

const dpad = [
  #("A", [#("v", ">"), #("<", "^")]), #("^", [#(">", "A"), #("v", "v")]),
  #(">", [#("^", "A"), #("<", "v")]),
  #("v", [#("^", "^"), #(">", ">"), #("<", "<")]), #("<", [#(">", "v")]),
]

type Memo =
  dict.Dict(#(String, String, Int), Int)

fn press(
  dpad: Graph,
  from: String,
  to: String,
  depth: Int,
  memo: Memo,
) -> #(Int, Memo) {
  use <- bool.guard(depth == 0, #(1, memo))
  use <- bool.lazy_guard(dict.has_key(memo, #(from, to, depth)), fn() {
    let assert Ok(v) = dict.get(memo, #(from, to, depth))
    #(v, memo)
  })

  let #(cost, memo) =
    dpad.paths
    |> dict.get(#(from, to))
    |> result.unwrap([])
    |> min_path_cost(dpad, depth - 1, memo)
  #(cost, memo |> dict.insert(#(from, to, depth), cost))
}

fn min_path_cost(
  paths: List(String),
  dpad: Graph,
  depth: Int,
  memo: Memo,
) -> #(Int, Memo) {
  paths
  |> list.fold(#(9_999_999_999_999, memo), fn(acc, path) {
    let #(_, cost, memo) =
      path
      |> string.to_graphemes
      |> list.fold(#("A", 0, acc.1), fn(acc, c) {
        let #(prev, cost, memo) = acc
        let #(cost2, memo) = press(dpad, prev, c, depth, memo)
        #(c, cost + cost2, memo)
      })

    #(int.min(acc.0, cost), memo)
  })
}

fn solve(keypad: Graph, dpad: Graph, s: String, n: Int) {
  s
  |> string.to_graphemes
  |> list.fold(#("A", list.new()), fn(acc, c) {
    #(
      c,
      keypad.paths
        |> dict.get(#(acc.0, c))
        |> result.unwrap([])
        |> list.flat_map(fn(x) {
          case acc.1 {
            [] -> [x]
            xs -> xs |> list.map(fn(y) { y <> x })
          }
        }),
    )
  })
  |> pair.second
  |> min_path_cost(dpad, n, dict.new())
  |> pair.first
}

fn build_graph(keypad: List(#(String, List(#(String, String))))) -> Graph {
  let edges = dict.from_list(keypad)
  let paths =
    edges
    |> dict.keys
    |> list.fold(dict.new(), fn(acc, i) {
      edges
      |> dict.keys
      |> list.fold(acc, fn(acc, j) {
        let q =
          pq.new(fn(a: #(String, String, Int), b) { int.compare(a.2, b.2) })
          |> pq.push(#("", i, 0))
        let paths = bfs_loop(edges, q, j, [])
        acc |> dict.insert(#(i, j), paths)
      })
    })

  Graph(edges, paths)
}

pub fn part1(s: String) -> Result(String, String) {
  let keypad = build_graph(keypad)
  let dpad = build_graph(dpad)
  s
  |> string.split("\n")
  |> list.map(fn(line) {
    {
      line
      |> string.to_graphemes
      |> list.filter(fn(c) { c != "A" })
      |> string.concat
      |> int.parse
      |> result.unwrap(0)
    }
    * { solve(keypad, dpad, line, 2) }
  })
  |> int.sum
  |> int.to_string
  |> Ok
}

pub fn part2(s: String) -> Result(String, String) {
  let keypad = build_graph(keypad)
  let dpad = build_graph(dpad)
  s
  |> string.split("\n")
  |> list.map(fn(line) {
    {
      line
      |> string.to_graphemes
      |> list.filter(fn(c) { c != "A" })
      |> string.concat
      |> int.parse
      |> result.unwrap(0)
    }
    * { solve(keypad, dpad, line, 25) }
  })
  |> int.sum
  |> int.to_string
  |> Ok
}
