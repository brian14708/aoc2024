import day19
import gleam/string
import gleeunit/should

pub fn day19_test() {
  let s =
    "
TODO
"
    |> string.trim
  day19.part1(s) |> should.equal(Error("unimplemented"))
  day19.part2(s) |> should.equal(Error("unimplemented"))
}
