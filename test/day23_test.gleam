import day23
import gleam/string
import gleeunit/should

pub fn day23_test() {
  let s =
    "
TODO
"
    |> string.trim
  day23.part1(s) |> should.equal(Error("unimplemented"))
  day23.part2(s) |> should.equal(Error("unimplemented"))
}
