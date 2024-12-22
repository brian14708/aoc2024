import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam/string

fn parse(s: String) -> Result(List(#(Int, Int)), Nil) {
  s
  |> string.split("\n")
  |> list.try_map(fn(x) {
    x
    |> string.split(",")
    |> list.try_map(int.parse)
    |> result.then(fn(l) {
      case l {
        [a, b] -> Ok(#(a, b))
        _ -> Error(Nil)
      }
    })
  })
}

type Map {
  Map(size: Int, corrupted: set.Set(#(Int, Int)))
}

fn bfs_loop(
  map: Map,
  end: #(Int, Int),
  queue: List(#(Int, Int, Int)),
  visited: set.Set(#(Int, Int)),
) -> Int {
  case queue {
    [current, ..rest] -> {
      use <- bool.guard(current.0 == end.0 && current.1 == end.0, current.2)
      use <- bool.lazy_guard(
        current.0 < 0
          || current.0 >= map.size
          || current.1 < 0
          || current.1 >= map.size
          || set.contains(visited, #(current.0, current.1))
          || set.contains(map.corrupted, #(current.0, current.1)),
        fn() { bfs_loop(map, end, rest, visited) },
      )
      bfs_loop(
        map,
        end,
        list.append(rest, [
          #(current.0 + 1, current.1, current.2 + 1),
          #(current.0 - 1, current.1, current.2 + 1),
          #(current.0, current.1 + 1, current.2 + 1),
          #(current.0, current.1 - 1, current.2 + 1),
        ]),
        set.insert(visited, #(current.0, current.1)),
      )
    }
    [] -> -1
  }
}

pub fn part1_impl(s: String, size: Int, count: Int) -> Result(String, String) {
  use input <- result.try(parse(s) |> result.replace_error("parse error"))
  Map(size, set.from_list(input |> list.take(count)))
  |> bfs_loop(#(size - 1, size - 1), [#(0, 0, 0)], set.new())
  |> int.to_string
  |> Ok
}

pub fn part1(s: String) -> Result(String, String) {
  part1_impl(s, 71, 1024)
}

pub fn part2_impl(s: String, size: Int) -> Result(String, String) {
  use input <- result.try(parse(s) |> result.replace_error("parse error"))
  let assert Ok(idx) =
    list.range(1, list.length(input))
    |> list.find_map(fn(n) {
      let input = input |> list.take(n)
      case
        Map(size, set.from_list(input))
        |> bfs_loop(#(size - 1, size - 1), [#(0, 0, 0)], set.new())
        == -1
      {
        True -> Ok(list.last(input) |> result.unwrap(#(-1, -1)))
        False -> Error(Nil)
      }
    })

  [int.to_string(idx.0), int.to_string(idx.1)]
  |> string.join(",")
  |> Ok
}

pub fn part2(s: String) -> Result(String, String) {
  part2_impl(s, 71)
}
