import day14
import gleam/string
import gleeunit/should

pub fn day14_test() {
  let s =
    "
TODO
"
    |> string.trim
  day14.part1(s) |> should.equal(Error("unimplemented"))
  day14.part2(s) |> should.equal(Error("unimplemented"))
}
