import day19
import gleam/string
import gleeunit/should

pub fn day19_test() {
  let s =
    "
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb
"
    |> string.trim
  day19.part1(s) |> should.equal(Ok("6"))
  day19.part2(s) |> should.equal(Ok("16"))
}
