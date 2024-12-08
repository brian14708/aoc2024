import day12
import gleam/string
import gleeunit/should

pub fn day12_test() {
  let s =
    "
TODO
"
    |> string.trim
  day12.part1(s) |> should.equal(Error("unimplemented"))
  day12.part2(s) |> should.equal(Error("unimplemented"))
}
