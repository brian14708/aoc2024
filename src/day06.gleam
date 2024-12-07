import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/set
import gleam/string

type Direction {
  Up
  Down
  Left
  Right
}

fn parse(s: String) {
  let lines = string.split(s, "\n")
  let #(map, start) =
    lines
    |> list.index_fold(#(dict.new(), #(-1, -1)), fn(acc, line, i) {
      line
      |> string.to_graphemes
      |> list.index_fold(acc, fn(acc, c, j) {
        case c {
          "#" -> {
            #(dict.insert(acc.0, #(i, j), True), acc.1)
          }
          "^" -> #(dict.insert(acc.0, #(i, j), False), #(i, j))
          "." -> #(dict.insert(acc.0, #(i, j), False), acc.1)
          _ -> acc
        }
      })
    })

  #(map, start)
}

fn move(
  map: dict.Dict(#(Int, Int), Bool),
  state: set.Set(#(Int, Int)),
  row: Int,
  col: Int,
  direction: Direction,
) -> set.Set(#(Int, Int)) {
  let state = set.insert(state, #(row, col))
  let #(next_row, next_col) = case direction {
    Up -> #(row - 1, col)
    Down -> #(row + 1, col)
    Left -> #(row, col - 1)
    Right -> #(row, col + 1)
  }

  case dict.get(map, #(next_row, next_col)) {
    Ok(True) -> {
      let next_direction = case direction {
        Up -> Right
        Down -> Left
        Left -> Up
        Right -> Down
      }
      move(map, state, row, col, next_direction)
    }
    Ok(False) -> move(map, state, next_row, next_col, direction)
    Error(_) -> state
  }
}

fn move_loop(
  map: dict.Dict(#(Int, Int), Bool),
  state: set.Set(#(Int, Int, Direction)),
  row: Int,
  col: Int,
  direction: Direction,
) -> #(set.Set(#(Int, Int, Direction)), Bool) {
  let #(next_row, next_col) = case direction {
    Up -> #(row - 1, col)
    Down -> #(row + 1, col)
    Left -> #(row, col - 1)
    Right -> #(row, col + 1)
  }

  case dict.get(map, #(next_row, next_col)) {
    Ok(True) -> {
      use <- bool.guard(set.contains(state, #(row, col, direction)), #(
        state,
        True,
      ))

      move_loop(map, set.insert(state, #(row, col, direction)), row, col, case
        direction
      {
        Up -> Right
        Down -> Left
        Left -> Up
        Right -> Down
      })
    }
    Ok(False) -> move_loop(map, state, next_row, next_col, direction)
    Error(_) -> #(state, False)
  }
}

pub fn part1(s: String) {
  let #(map, #(start_row, start_col)) = parse(s)
  move(map, set.new(), start_row, start_col, Up)
  |> set.size
  |> int.to_string
  |> Ok
}

pub fn part2(s: String) {
  let #(map, #(start_row, start_col)) = parse(s)
  let positions = move(map, set.new(), start_row, start_col, Up)
  positions
  |> set.delete(#(start_row, start_col))
  |> set.to_list
  |> list.count(fn(p) {
    let new_map = dict.insert(map, p, True)
    let #(_, loop) = move_loop(new_map, set.new(), start_row, start_col, Up)
    loop
  })
  |> int.to_string
  |> Ok
}
