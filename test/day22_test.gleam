import day22
import gleam/string
import gleeunit/should

pub fn day22_test() {
  let s =
    "
1
10
100
2024
"
    |> string.trim
  day22.part1(s) |> should.equal(Ok("37327623"))
  let s2 =
    "
1
2
3
2024
"
    |> string.trim
  day22.part2(s2) |> should.equal(Ok("23"))
}
