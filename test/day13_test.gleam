import day13
import gleam/string
import gleeunit/should

pub fn day13_test() {
  let s =
    "
TODO
"
    |> string.trim
  day13.part1(s) |> should.equal(Error("unimplemented"))
  day13.part2(s) |> should.equal(Error("unimplemented"))
}
