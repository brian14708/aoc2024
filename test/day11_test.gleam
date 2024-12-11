import day11
import gleeunit/should

pub fn day11_test() {
  let s = "125 17"
  day11.part1(s) |> should.equal(Ok("55312"))
}
