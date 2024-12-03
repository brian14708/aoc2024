import gleam/int
import gleam/list
import gleam/option.{type Option}
import gleam/regexp
import gleam/result

fn parse_and_mul(s: List(Option(String))) -> Result(Int, String) {
  s
  |> list.try_map(fn(x) { x |> option.to_result(Nil) |> result.then(int.parse) })
  |> result.map(fn(x) { list.fold(x, 1, fn(x, y) { x * y }) })
  |> result.replace_error("invalid number")
}

pub fn part1(s: String) {
  let assert Ok(re) = regexp.from_string("mul\\((\\d{1,3}),(\\d{1,3})\\)")
  regexp.scan(re, s)
  |> list.try_map(fn(m) {
    let regexp.Match(_, submatch) = m
    parse_and_mul(submatch)
  })
  |> result.map(fn(products) { products |> int.sum |> int.to_string })
}

pub fn part2(s: String) {
  let assert Ok(re) =
    regexp.from_string("mul\\((\\d{1,3}),(\\d{1,3})\\)|don't\\(\\)|do\\(\\)")

  regexp.scan(re, s)
  |> list.try_fold(#(True, list.new()), fn(acc: #(Bool, List(Int)), el) {
    let #(enabled, out) = acc
    case enabled, el {
      _, regexp.Match("do()", _) -> Ok(#(True, out))
      _, regexp.Match("don't()", _) | False, regexp.Match(_, _) ->
        Ok(#(False, out))
      True, regexp.Match(_, submatch) -> {
        parse_and_mul(submatch)
        |> result.map(fn(nums) { #(True, list.append(out, [nums])) })
      }
    }
  })
  |> result.map(fn(x) { x.1 |> int.sum |> int.to_string })
}
