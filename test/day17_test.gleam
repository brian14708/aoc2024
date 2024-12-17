import day17
import gleam/string
import gleeunit/should

pub fn day17_test() {
  let s =
    "
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
"
    |> string.trim
  day17.part1(s) |> should.equal(Ok("4,6,3,5,6,3,5,2,1,0"))
  let s2 =
    "
Register A: 2024
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0
"
    |> string.trim
  day17.part2(s2) |> should.equal(Ok("117440"))
}
