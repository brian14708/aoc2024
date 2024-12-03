import day02
import gleam/string
import gleeunit/should

pub fn day02_test() {
  let s =
    "
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"
    |> string.trim
  day02.part1(s) |> should.equal(Ok("2"))
  day02.part2(s) |> should.equal(Ok("4"))
}
