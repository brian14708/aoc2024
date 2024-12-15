import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

type Element {
  Wall
  Stone
}

type ElementV2 {
  WallV2
  StoneV2L
  StoneV2R
}

fn move_pos(p: #(Int, Int), d: String) {
  case d {
    "<" -> #(p.0, p.1 - 1)
    ">" -> #(p.0, p.1 + 1)
    "^" -> #(p.0 - 1, p.1)
    "v" -> #(p.0 + 1, p.1)
    _ -> p
  }
}

fn move(
  map: dict.Dict(#(Int, Int), Element),
  current: #(Int, Int),
  direction: String,
) -> Result(dict.Dict(#(Int, Int), Element), Nil) {
  let new_pos = move_pos(current, direction)
  case dict.get(map, new_pos) {
    Ok(Wall) -> Error(Nil)
    Error(Nil) -> Ok(map)
    Ok(Stone) -> move(map, new_pos, direction)
  }
  |> result.map(fn(m) {
    case dict.get(m, current) {
      Ok(v) -> dict.delete(m, current) |> dict.insert(new_pos, v)
      Error(Nil) -> dict.delete(m, new_pos)
    }
  })
}

pub fn part1(s: String) -> Result(String, String) {
  let assert [map, instruction] = s |> string.split("\n\n")
  let #(map, start) =
    map
    |> string.split("\n")
    |> list.index_fold(#(dict.new(), #(-1, -1)), fn(acc, line, i) {
      line
      |> string.to_graphemes
      |> list.index_fold(acc, fn(acc, v, j) {
        case v {
          "@" -> #(acc.0, #(i, j))
          "#" -> #(dict.insert(acc.0, #(i, j), Wall), acc.1)
          "O" -> #(dict.insert(acc.0, #(i, j), Stone), acc.1)
          _ -> acc
        }
      })
    })

  instruction
  |> string.to_graphemes
  |> list.fold(#(map, start), fn(acc, direction) {
    let #(map, current) = acc
    case move(map, current, direction) {
      Ok(m) -> #(m, move_pos(current, direction))
      Error(Nil) -> #(map, current)
    }
  })
  |> pair.first
  |> dict.to_list
  |> list.filter_map(fn(d) {
    let #(pos, t) = d
    case t {
      Wall -> Error(Nil)
      Stone -> Ok(pos.0 * 100 + pos.1)
    }
  })
  |> int.sum
  |> int.to_string
  |> Ok
}

fn move2(
  map: dict.Dict(#(Int, Int), ElementV2),
  current: #(Int, Int),
  direction: String,
) -> Result(dict.Dict(#(Int, Int), ElementV2), Nil) {
  let new_pos = move_pos(current, direction)
  let vert = direction == "^" || direction == "v"
  case dict.get(map, new_pos) {
    Error(Nil) -> Ok(map)
    Ok(WallV2) -> Error(Nil)
    Ok(StoneV2L) ->
      move2(map, new_pos, direction)
      |> result.then(case vert {
        True -> fn(map) { move2(map, #(new_pos.0, new_pos.1 + 1), direction) }
        False -> Ok
      })
    Ok(StoneV2R) ->
      move2(map, new_pos, direction)
      |> result.then(case vert {
        True -> fn(map) { move2(map, #(new_pos.0, new_pos.1 - 1), direction) }
        False -> Ok
      })
  }
  |> result.map(fn(m) {
    case dict.get(m, current) {
      Ok(v) -> dict.delete(m, current) |> dict.insert(new_pos, v)
      Error(Nil) -> dict.delete(m, new_pos)
    }
  })
}

pub fn part2(s: String) -> Result(String, String) {
  let assert [map, instruction] = s |> string.split("\n\n")
  let #(map, start) =
    map
    |> string.split("\n")
    |> list.index_fold(#(dict.new(), #(-1, -1)), fn(acc, line, i) {
      line
      |> string.to_graphemes
      |> list.index_fold(acc, fn(acc, v, j) {
        case v {
          "@" -> #(acc.0, #(i, j * 2))
          "#" -> #(
            acc.0
              |> dict.insert(#(i, j * 2), WallV2)
              |> dict.insert(#(i, j * 2 + 1), WallV2),
            acc.1,
          )
          "O" -> #(
            acc.0
              |> dict.insert(#(i, j * 2), StoneV2L)
              |> dict.insert(#(i, j * 2 + 1), StoneV2R),
            acc.1,
          )
          _ -> acc
        }
      })
    })

  instruction
  |> string.to_graphemes
  |> list.fold(#(map, start), fn(acc, direction) {
    let #(map, current) = acc
    case move2(map, current, direction) {
      Ok(m) -> #(m, move_pos(current, direction))
      Error(Nil) -> #(map, current)
    }
  })
  |> pair.first
  |> dict.to_list
  |> list.filter_map(fn(d) {
    let #(pos, t) = d
    case t {
      WallV2 -> Error(Nil)
      StoneV2L -> Ok(pos.0 * 100 + pos.1)
      _ -> Error(Nil)
    }
  })
  |> int.sum
  |> int.to_string
  |> Ok
}
