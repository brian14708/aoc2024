import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam/string

fn t(a: Int) -> Int {
  let a = int.bitwise_exclusive_or(a * 64, a) % 16_777_216
  let a = int.bitwise_exclusive_or(a / 32, a) % 16_777_216
  int.bitwise_exclusive_or(a * 2048, a) % 16_777_216
}

pub fn part1(s: String) -> Result(String, String) {
  s
  |> string.split("\n")
  |> list.try_map(int.parse)
  |> result.unwrap([])
  |> list.map(fn(x) {
    list.range(1, 2000) |> list.fold(x, fn(acc, _) { t(acc) })
  })
  |> int.sum
  |> int.to_string
  |> Ok
}

fn encode(a: Int, b: Int, c: Int, d: Int) -> Int {
  int.bitwise_shift_left(a + 10, 18)
  + int.bitwise_shift_left(b + 10, 12)
  + int.bitwise_shift_left(c + 10, 6)
  + { d + 10 }
}

fn solve(l: List(Int)) -> Int {
  let prices =
    l
    |> list.map(fn(x) {
      list.range(1, 2001)
      |> list.fold(#([x], x), fn(acc, _) {
        let v = t(acc.1)
        #(list.append([v % 10], acc.0), v)
      })
      |> fn(x) { list.reverse(x.0) }
      |> list.window_by_2
      |> list.map(fn(x) { #(x.1, x.1 - x.0) })
      |> list.window(4)
      |> list.fold(dict.new(), fn(acc, win) {
        let assert [a, b, c, d] = win
        let key = encode(a.1, b.1, c.1, d.1)
        case dict.has_key(acc, key) {
          True -> acc
          False -> dict.insert(acc, key, d.0)
        }
      })
    })

  prices
  |> list.fold(set.new(), fn(acc, x) {
    dict.keys(x) |> list.fold(acc, fn(acc, k) { set.insert(acc, k) })
  })
  |> set.to_list
  |> list.fold(0, fn(acc, k) {
    int.max(acc, prices |> list.filter_map(fn(p) { dict.get(p, k) }) |> int.sum)
  })
}

pub fn part2(s: String) -> Result(String, String) {
  s
  |> string.split("\n")
  |> list.try_map(int.parse)
  |> result.unwrap([])
  |> solve
  |> int.to_string
  |> Ok
}
