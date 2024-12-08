import day20
import gleam/string
import gleeunit/should

pub fn day20_test() {
  let s =
    "
TODO
"
    |> string.trim
  day20.part1(s) |> should.equal(Error("unimplemented"))
  day20.part2(s) |> should.equal(Error("unimplemented"))
}
