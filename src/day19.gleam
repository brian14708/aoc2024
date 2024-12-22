import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn parse(s: String) -> #(List(String), List(String)) {
  let assert [s, t] = string.split(s, "\n\n")
  #(string.split(s, ", "), string.split(t, "\n"))
}

fn search(target: String, src: List(String)) -> Bool {
  list.fold(list.range(1, string.length(target)), [True], fn(dp, i) {
    let target = string.slice(target, 0, i)
    list.append(dp, [
      list.fold(src, False, fn(acc, suffix) {
        acc
        || {
          string.ends_with(target, suffix)
          && {
            list.drop(dp, i - string.length(suffix))
            |> list.first
            |> result.unwrap(False)
          }
        }
      }),
    ])
  })
  |> list.last
  |> result.unwrap(False)
}

pub fn part1(s: String) -> Result(String, String) {
  let #(src, target) = parse(s)
  target
  |> list.count(fn(pattern) { search(pattern, src) })
  |> int.to_string
  |> Ok
}

fn search2(target: String, src: List(String)) -> Int {
  list.fold(list.range(1, string.length(target)), [1], fn(dp, i) {
    let target = string.slice(target, 0, i)
    list.append(dp, [
      list.fold(src, 0, fn(acc, suffix) {
        acc
        + {
          case string.ends_with(target, suffix) {
            True -> {
              list.drop(dp, i - string.length(suffix))
              |> list.first
              |> result.unwrap(0)
            }
            False -> 0
          }
        }
      }),
    ])
  })
  |> list.last
  |> result.unwrap(0)
}

pub fn part2(s: String) -> Result(String, String) {
  let #(src, target) = parse(s)
  target
  |> list.map(fn(pattern) { search2(pattern, src) })
  |> int.sum
  |> int.to_string
  |> Ok
}
