import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam/string

fn parse(s: String) {
  s
  |> string.split("\n")
  |> list.index_fold(dict.new(), fn(map, line, i) {
    line
    |> string.to_graphemes
    |> list.try_map(int.parse)
    |> result.unwrap([])
    |> list.index_fold(map, fn(map, x, j) { dict.insert(map, #(i, j), x) })
  })
}

fn traverse(map: dict.Dict(#(Int, Int), Int), curr: #(Int, Int)) {
  case dict.get(map, curr) {
    Ok(9) -> set.from_list([curr])
    Ok(val) ->
      [
        #(curr.0 + 1, curr.1),
        #(curr.0 - 1, curr.1),
        #(curr.0, curr.1 + 1),
        #(curr.0, curr.1 - 1),
      ]
      |> list.fold(set.new(), fn(acc, pos) {
        use <- bool.guard(Ok(val + 1) != dict.get(map, pos), acc)
        set.union(acc, traverse(map, pos))
      })
    Error(_) -> set.new()
  }
}

pub fn part1(s: String) -> Result(String, String) {
  let map = parse(s)
  map
  |> dict.filter(fn(_k, v) { v == 0 })
  |> dict.keys
  |> list.map(fn(pos) { traverse(map, pos) })
  |> list.map(set.size)
  |> int.sum
  |> int.to_string
  |> Ok
}

fn traverse2(map: dict.Dict(#(Int, Int), Int), curr: #(Int, Int)) {
  case dict.get(map, curr) {
    Ok(9) -> 1
    Ok(val) ->
      [
        #(curr.0 + 1, curr.1),
        #(curr.0 - 1, curr.1),
        #(curr.0, curr.1 + 1),
        #(curr.0, curr.1 - 1),
      ]
      |> list.fold(0, fn(acc, pos) {
        use <- bool.guard(Ok(val + 1) != dict.get(map, pos), acc)
        acc + traverse2(map, pos)
      })
    Error(_) -> 0
  }
}

pub fn part2(s: String) -> Result(String, String) {
  let map = parse(s)
  map
  |> dict.filter(fn(_k, v) { v == 0 })
  |> dict.keys
  |> list.map(fn(pos) { traverse2(map, pos) })
  |> int.sum
  |> int.to_string
  |> Ok
}
