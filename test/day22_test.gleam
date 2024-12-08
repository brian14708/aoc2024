import day22
import gleam/string
import gleeunit/should

pub fn day22_test() {
  let s =
    "
TODO
"
    |> string.trim
  day22.part1(s) |> should.equal(Error("unimplemented"))
  day22.part2(s) |> should.equal(Error("unimplemented"))
}
