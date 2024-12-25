import day21
import gleam/string
import gleeunit/should

pub fn day21_test() {
  let s =
    "
029A
980A
179A
456A
379A
"
    |> string.trim
  day21.part1("029A") |> should.equal(Ok("1972"))
  day21.part1(s) |> should.equal(Ok("126384"))
}
