import gleam/bool
import gleam/int
import gleam/list
import gleam/order
import gleam/result
import gleam/string

fn parse(s: String) {
  s
  |> string.to_graphemes
  |> list.try_map(int.parse)
  |> result.unwrap([])
  |> list.index_fold(#([], [], 0), fn(acc, x, i) {
    let #(files, empty, length) = acc
    case x, i % 2 == 0 {
      0, _ -> #(files, empty, length)
      x, True -> #(
        list.append(files, [#(i / 2, length, length + x - 1)]),
        empty,
        length + x,
      )
      x, False -> #(
        files,
        list.append(empty, [#(length, length + x - 1)]),
        length + x,
      )
    }
  })
}

fn sum(from: Int, to: Int) {
  { to * { to + 1 } - from * { from - 1 } } / 2
}

fn index_sum(x: List(#(Int, Int, Int))) {
  x
  |> list.fold(0, fn(acc, a) { acc + sum(a.1, a.2) * a.0 })
  |> int.to_string
  |> Ok
}

fn move_list(files: List(#(Int, Int, Int)), empty: List(#(Int, Int))) {
  case files, empty {
    files, [] -> files
    [], _ -> []
    [f, ..fs], [e, ..es] -> {
      use <- bool.guard(f.1 < e.0, files)
      case int.compare(f.2 - f.1, e.1 - e.0) {
        order.Eq -> list.append([#(f.0, e.0, e.1)], move_list(fs, es))
        order.Gt ->
          list.append(
            [#(f.0, e.0, e.1)],
            move_list(
              list.append([#(f.0, f.1, f.2 - { e.1 - e.0 + 1 })], fs),
              es,
            ),
          )
        order.Lt ->
          list.append(
            [#(f.0, e.0, e.0 + f.2 - f.1)],
            move_list(fs, list.append([#(e.0 + f.2 - f.1 + 1, e.1)], es)),
          )
      }
    }
  }
}

pub fn part1(s: String) -> Result(String, String) {
  let #(files, empty, _) = parse(s)

  files
  |> list.reverse
  |> move_list(empty)
  |> index_sum
}

fn move_list_2(files: List(#(Int, Int, Int)), empty: List(#(Int, Int))) {
  case files, empty {
    files, [] -> files
    [], _ -> []
    [f, ..fs], e ->
      case
        list.split_while(e, fn(e) { !{ e.0 < f.1 && e.1 - e.0 >= f.2 - f.1 } })
      {
        // not found
        #(es, []) -> list.append([f], move_list_2(fs, es))
        // found
        #(head, [slot, ..tail]) -> {
          list.append(
            [#(f.0, slot.0, slot.0 + f.2 - f.1)],
            move_list_2(fs, case slot.1 - slot.0 == f.2 - f.1 {
              True -> list.append(head, tail)
              False ->
                list.flatten([head, [#(slot.0 + f.2 - f.1 + 1, slot.1)], tail])
            }),
          )
        }
      }
  }
}

pub fn part2(s: String) -> Result(String, String) {
  let #(files, empty, _) = parse(s)
  files
  |> list.reverse
  |> move_list_2(empty)
  |> index_sum
}
