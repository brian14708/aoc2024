import day09
import gleeunit/should

pub fn day09_test() {
  let s = "2333133121414131402"
  day09.part1(s) |> should.equal(Ok("1928"))
  day09.part2(s) |> should.equal(Ok("2858"))
}
