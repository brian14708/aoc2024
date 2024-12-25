import day25
import gleam/string
import gleeunit/should

pub fn day25_test() {
  let s =
    "
#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####
"
    |> string.trim
  day25.part1(s) |> should.equal(Ok("3"))
}
