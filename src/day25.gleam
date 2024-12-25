import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/set
import gleam/string

fn parse(s: String) -> #(Bool, List(Int)) {
  let coord =
    s
    |> string.split("\n")
    |> list.index_fold(set.new(), fn(result, line, row) {
      line
      |> string.to_graphemes
      |> list.index_fold(result, fn(result, char, col) {
        case char {
          "#" -> set.insert(result, #(row, col))
          _ -> result
        }
      })
    })
  let is_lock = set.contains(coord, #(0, 0))
  #(
    is_lock,
    coord
      |> set.to_list
      |> list.fold(dict.new(), fn(acc, c) {
        dict.upsert(acc, c.1, fn(v) {
          case v {
            option.None -> c.0
            option.Some(v) ->
              case is_lock {
                True -> int.max(c.0, v)
                False -> int.min(c.0, v)
              }
          }
        })
      })
      |> dict.to_list
      |> list.sort(fn(a, b) { int.compare(a.0, b.0) })
      |> list.map(fn(a) {
        case is_lock {
          True -> a.1
          False -> 6 - a.1
        }
      }),
  )
}

pub fn part1(s: String) -> Result(String, String) {
  let data = s |> string.split("\n\n") |> list.map(parse)
  data
  |> list.filter(fn(a) { a.0 })
  |> list.map(fn(lock) {
    data
    |> list.filter(fn(a) { !a.0 })
    |> list.filter(fn(key) {
      list.zip(lock.1, key.1)
      |> list.all(fn(a) { a.0 + a.1 < 6 })
    })
    |> list.length
  })
  |> int.sum
  |> int.to_string
  |> Ok
}

pub fn part2(_s: String) -> Result(String, String) {
  Ok("YAY")
}
