import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/set
import gleam/string

type Map {
  Map(
    walls: set.Set(#(Int, Int)),
    start: #(Int, Int),
    end: #(Int, Int),
    size: #(Int, Int),
  )
}

fn parse(s: String) -> Map {
  string.split(s, "\n")
  |> list.index_fold(
    Map(set.new(), #(-1, -1), #(-1, -1), #(-1, -1)),
    fn(map, line, y) {
      string.split(line, "")
      |> list.index_fold(map, fn(map, c, x) {
        case c {
          "#" ->
            Map(set.insert(map.walls, #(x, y)), map.start, map.end, map.size)
          "S" ->
            Map(map.walls, #(x, y), map.end, #(
              string.length(line),
              string.length(s),
            ))
          "E" -> Map(map.walls, map.start, #(x, y), map.size)
          _ -> map
        }
      })
    },
  )
}

fn solve(
  map: Map,
  start: #(Int, Int),
  visited: set.Set(#(Int, Int)),
  solution: List(#(Int, Int)),
) -> Result(List(#(Int, Int)), Nil) {
  case start == map.end {
    True -> Ok(solution)
    False -> {
      let assert [step] =
        [
          #(start.0 + 1, start.1),
          #(start.0 - 1, start.1),
          #(start.0, start.1 + 1),
          #(start.0, start.1 - 1),
        ]
        |> list.filter(fn(p) {
          !set.contains(visited, p) && !set.contains(map.walls, p)
        })
      solve(map, step, set.insert(visited, step), list.append([step], solution))
    }
  }
}

pub fn part1_impl(
  s: String,
  max_cheat: Int,
  lower: Int,
) -> Result(String, String) {
  let map = parse(s)
  let assert Ok(solution) =
    solve(map, map.start, set.from_list([map.start]), [map.start])
    |> result.map(list.reverse)
  solution
  |> list.index_fold(dict.new(), fn(acc, dst, i) {
    list.take(solution, i)
    |> list.index_fold(acc, fn(acc, src, j) {
      let dist =
        int.absolute_value(src.0 - dst.0) + int.absolute_value(src.1 - dst.1)
      let dist2 = i - j

      case dist <= max_cheat && dist2 > dist {
        False -> acc
        True ->
          dict.upsert(acc, dist2 - dist, fn(v) {
            case v {
              option.None -> 1
              option.Some(v) -> v + 1
            }
          })
      }
    })
  })
  |> dict.to_list
  |> list.filter(fn(k) { k.0 >= lower })
  |> list.map(fn(k) { k.1 })
  |> int.sum
  |> int.to_string
  |> Ok
}

pub fn part1(s: String) -> Result(String, String) {
  part1_impl(s, 2, 100)
}

pub fn part2(s: String) -> Result(String, String) {
  part1_impl(s, 20, 100)
}
