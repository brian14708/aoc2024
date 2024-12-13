import day12
import gleam/string
import gleeunit/should

pub fn day12_test() {
  let s =
    "
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
"
    |> string.trim
  day12.part1(s) |> should.equal(Ok("1930"))
  day12.part2(s) |> should.equal(Ok("1206"))
}
