import day09
import gleam/string
import gleeunit/should

pub fn day09_test() {
  let s =
    "
TODO
"
    |> string.trim
  day09.part1(s) |> should.equal(Error("unimplemented"))
  day09.part2(s) |> should.equal(Error("unimplemented"))
}
