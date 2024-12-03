import day03
import gleam/string
import gleeunit/should

pub fn day03_test() {
  let s1 =
    "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    |> string.trim
  day03.part1(s1) |> should.equal(Ok("161"))
  let s2 =
    "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  day03.part2(s2) |> should.equal(Ok("48"))
}
