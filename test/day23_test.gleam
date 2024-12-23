import day23
import gleam/string
import gleeunit/should

pub fn day23_test() {
  let s =
    "
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
"
    |> string.trim
  day23.part1(s) |> should.equal(Ok("7"))
  day23.part2(s) |> should.equal(Ok("co,de,ka,ta"))
}
