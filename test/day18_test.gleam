import day18
import gleam/string
import gleeunit/should

pub fn day18_test() {
  let s =
    "
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0
"
    |> string.trim
  day18.part1_impl(s, 7, 12) |> should.equal(Ok("22"))
  day18.part2_impl(s, 7) |> should.equal(Ok("6,1"))
}
