import day17
import gleam/string
import gleeunit/should

pub fn day17_test() {
  let s =
    "
TODO
"
    |> string.trim
  day17.part1(s) |> should.equal(Error("unimplemented"))
  day17.part2(s) |> should.equal(Error("unimplemented"))
}
