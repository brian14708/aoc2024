import day10
import gleam/string
import gleeunit/should

pub fn day10_test() {
  let s =
    "
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
"
    |> string.trim
  day10.part1(s) |> should.equal(Ok("36"))
  day10.part2(s) |> should.equal(Ok("81"))
}
