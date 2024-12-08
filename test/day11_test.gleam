import day11
import gleam/string
import gleeunit/should

pub fn day11_test() {
  let s =
    "
TODO
"
    |> string.trim
  day11.part1(s) |> should.equal(Error("unimplemented"))
  day11.part2(s) |> should.equal(Error("unimplemented"))
}
