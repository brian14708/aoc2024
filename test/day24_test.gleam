import day24
import gleam/string
import gleeunit/should

pub fn day24_test() {
  let s =
    "
TODO
"
    |> string.trim
  day24.part1(s) |> should.equal(Error("unimplemented"))
  day24.part2(s) |> should.equal(Error("unimplemented"))
}
