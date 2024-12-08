import day25
import gleam/string
import gleeunit/should

pub fn day25_test() {
  let s =
    "
TODO
"
    |> string.trim
  day25.part1(s) |> should.equal(Error("unimplemented"))
  day25.part2(s) |> should.equal(Error("unimplemented"))
}
