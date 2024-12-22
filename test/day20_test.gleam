import day20
import gleam/string
import gleeunit/should

pub fn day20_test() {
  let s =
    "
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
"
    |> string.trim
  day20.part1_impl(s, 2, 20) |> should.equal(Ok("5"))
  day20.part1_impl(s, 20, 70) |> should.equal(Ok("41"))
}
