import day07
import gleam/string
import gleeunit/should

pub fn day07_test() {
  let s =
    "
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
"
    |> string.trim
  day07.part1(s) |> should.equal(Ok("3749"))
  day07.part2(s) |> should.equal(Ok("11387"))
}
