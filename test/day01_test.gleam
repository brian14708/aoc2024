import day01
import gleam/string
import gleeunit/should

pub fn day01_test() {
  let s =
    "
3   4
4   3
2   5
1   3
3   9
3   3
"
    |> string.trim
  day01.part1(s) |> should.equal(Ok("11"))
  day01.part2(s) |> should.equal(Ok("31"))
}
