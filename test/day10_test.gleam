import day10
import gleam/string
import gleeunit/should

pub fn day10_test() {
  let s =
    "
TODO
"
    |> string.trim
  day10.part1(s) |> should.equal(Error("unimplemented"))
  day10.part2(s) |> should.equal(Error("unimplemented"))
}
