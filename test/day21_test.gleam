import day21
import gleam/string
import gleeunit/should

pub fn day21_test() {
  let s =
    "
TODO
"
    |> string.trim
  day21.part1(s) |> should.equal(Error("unimplemented"))
  day21.part2(s) |> should.equal(Error("unimplemented"))
}
