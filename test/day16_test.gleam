import day16
import gleam/string
import gleeunit/should

pub fn day16_test() {
  let s =
    "
TODO
"
    |> string.trim
  day16.part1(s) |> should.equal(Error("unimplemented"))
  day16.part2(s) |> should.equal(Error("unimplemented"))
}
