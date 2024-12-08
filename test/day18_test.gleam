import day18
import gleam/string
import gleeunit/should

pub fn day18_test() {
  let s =
    "
TODO
"
    |> string.trim
  day18.part1(s) |> should.equal(Error("unimplemented"))
  day18.part2(s) |> should.equal(Error("unimplemented"))
}
