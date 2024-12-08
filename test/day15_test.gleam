import day15
import gleam/string
import gleeunit/should

pub fn day15_test() {
  let s =
    "
TODO
"
    |> string.trim
  day15.part1(s) |> should.equal(Error("unimplemented"))
  day15.part2(s) |> should.equal(Error("unimplemented"))
}
