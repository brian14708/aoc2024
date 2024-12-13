import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/set
import gleam/string

fn parse(s: String) {
  s
  |> string.split("\n")
  |> list.index_fold(dict.new(), fn(acc, line, i) {
    line
    |> string.to_graphemes
    |> list.index_fold(acc, fn(acc, ch, j) { dict.insert(acc, #(i, j), ch) })
  })
}

fn flood_fill(
  map: dict.Dict(#(Int, Int), String),
  pos: #(Int, Int),
  state: set.Set(#(Int, Int)),
) -> set.Set(#(Int, Int)) {
  use <- bool.guard(set.contains(state, pos), state)
  let state = set.insert(state, pos)
  let assert Ok(t) = dict.get(map, pos)

  [
    #(pos.0 - 1, pos.1),
    #(pos.0 + 1, pos.1),
    #(pos.0, pos.1 + 1),
    #(pos.0, pos.1 - 1),
  ]
  |> list.fold(state, fn(state, new_pos) {
    case dict.get(map, new_pos) == Ok(t) {
      True -> flood_fill(map, new_pos, state)
      False -> state
    }
  })
}

fn split_region(
  map: dict.Dict(#(Int, Int), String),
) -> List(#(String, set.Set(#(Int, Int)))) {
  map
  |> dict.to_list
  |> list.fold(list.new(), fn(acc, v) {
    let #(pos, ch) = v
    case
      list.find(acc, fn(c: #(String, set.Set(#(Int, Int)))) {
        set.contains(c.1, pos)
      })
    {
      Ok(_) -> acc
      Error(_) -> list.append([#(ch, flood_fill(map, pos, set.new()))], acc)
    }
  })
}

fn price(region: set.Set(#(Int, Int))) {
  let area = set.size(region)
  let neigh =
    region
    |> set.to_list
    |> list.map(fn(pos) {
      [
        #(pos.0 - 1, pos.1),
        #(pos.0 + 1, pos.1),
        #(pos.0, pos.1 - 1),
        #(pos.0, pos.1 + 1),
      ]
      |> list.count(fn(n) { set.contains(region, n) })
    })
    |> int.sum
  area * { area * 4 - neigh }
}

pub fn part1(s: String) -> Result(String, String) {
  s
  |> parse
  |> split_region
  |> list.map(fn(v) { price(v.1) })
  |> int.sum
  |> int.to_string
  |> Ok
}

fn price2(region: set.Set(#(Int, Int))) {
  let area = set.size(region)
  let neigh =
    region
    |> set.to_list
    |> list.map(fn(pos) {
      let edge =
        [
          [
            #(pos.0 - 1, pos.1 - 1),
            #(pos.0 - 1, pos.1),
            #(pos.0 - 1, pos.1 + 1),
          ],
          [#(pos.0, pos.1 - 1), #(pos.0, pos.1), #(pos.0, pos.1 + 1)],
          [
            #(pos.0 + 1, pos.1 - 1),
            #(pos.0 + 1, pos.1),
            #(pos.0 + 1, pos.1 + 1),
          ],
        ]
        |> list.map(fn(n) { list.map(n, fn(n) { set.contains(region, n) }) })

      let outer =
        case edge {
          [[_, False, _], [False, _, _], [_, _, _]] -> 1
          _ -> 0
        }
        + case edge {
          [[_, _, _], [False, _, _], [_, False, _]] -> 1
          _ -> 0
        }
        + case edge {
          [[_, _, _], [_, _, False], [_, False, _]] -> 1
          _ -> 0
        }
        + case edge {
          [[_, False, _], [_, _, False], [_, _, _]] -> 1
          _ -> 0
        }

      let inner =
        case edge {
          [[_, _, _], [_, _, True], [_, False, True]] -> 1
          _ -> 0
        }
        + case edge {
          [[_, False, True], [_, _, True], [_, _, _]] -> 1
          _ -> 0
        }
        + case edge {
          [[True, False, _], [True, _, _], [_, _, _]] -> 1
          _ -> 0
        }
        + case edge {
          [[_, _, _], [True, _, _], [True, False, _]] -> 1
          _ -> 0
        }

      outer + inner
    })
    |> int.sum
  area * neigh
}

pub fn part2(s: String) -> Result(String, String) {
  s
  |> parse
  |> split_region
  |> list.map(fn(v) { price2(v.1) })
  |> int.sum
  |> int.to_string
  |> Ok
}
