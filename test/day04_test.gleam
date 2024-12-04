import day04
import gleam/string
import gleeunit/should

pub fn day04_test() {
  let s =
    "
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"
    |> string.trim
  day04.part1(s) |> should.equal(Ok("18"))
  day04.part2(s) |> should.equal(Ok("9"))
}
