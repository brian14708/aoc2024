import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/set
import gleam/string

fn parse(s: String) -> #(dict.Dict(String, List(#(Int, Int))), #(Int, Int)) {
  let lines = s |> string.split("\n")
  let d =
    lines
    |> list.index_fold(dict.new(), fn(d, line, i) {
      line
      |> string.to_graphemes
      |> list.index_fold(d, fn(d, c, j) {
        case c {
          "." -> d
          _ ->
            dict.upsert(d, c, fn(v) {
              case v {
                option.Some(l) -> list.append(l, [#(i, j)])
                option.None -> [#(i, j)]
              }
            })
        }
      })
    })
  #(d, #(
    // rows
    list.length(lines),
    // cols
    lines |> list.first |> result.unwrap("") |> string.length,
  ))
}

pub fn part1(s: String) {
  let #(map, #(rows, cols)) = parse(s)

  dict.fold(map, set.new(), fn(antinodes, _freq, towers) {
    list.fold(towers, antinodes, fn(antinodes, position_a) {
      list.fold(towers, antinodes, fn(antinodes, position_b) {
        case position_a == position_b {
          True -> antinodes
          False -> {
            set.insert(antinodes, #(
              2 * position_b.0 - position_a.0,
              2 * position_b.1 - position_a.1,
            ))
          }
        }
      })
    })
  })
  |> set.filter(fn(p) { p.0 >= 0 && p.0 < rows && p.1 >= 0 && p.1 < cols })
  |> set.size
  |> int.to_string
  |> Ok
}

pub fn part2(s: String) {
  let #(map, #(rows, cols)) = parse(s)

  dict.fold(map, set.new(), fn(antinodes, _freq, towers) {
    list.fold(towers, antinodes, fn(antinodes, position_a) {
      list.fold(towers, antinodes, fn(antinodes, position_b) {
        case position_a == position_b {
          True -> antinodes
          False -> {
            let iter = int.max(rows, cols)
            list.fold(list.range(-1 * iter, iter), antinodes, fn(antinodes, n) {
              set.insert(antinodes, #(
                position_a.0 + n * { position_b.0 - position_a.0 },
                position_a.1 + n * { position_b.1 - position_a.1 },
              ))
            })
          }
        }
      })
    })
  })
  |> set.filter(fn(p) { p.0 >= 0 && p.0 < rows && p.1 >= 0 && p.1 < cols })
  |> set.size
  |> int.to_string
  |> Ok
}
