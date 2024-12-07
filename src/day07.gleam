import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn parse(s: String) {
  let lines = string.split(s, "\n")
  lines
  |> list.try_map(fn(line) {
    case
      line
      |> string.split(": ")
    {
      [a, b] -> {
        use base <- result.try(int.parse(a))
        use parts <- result.try(
          b
          |> string.split(" ")
          |> list.try_map(int.parse),
        )
        Ok(#(base, parts))
      }
      _ -> Error(Nil)
    }
  })
}

fn dfs(target: Int, parts: List(Int)) -> Bool {
  case parts {
    [] -> target == 0
    [t] -> target == t
    [head, ..tail] -> {
      dfs(target - head, tail)
      || { target % head == 0 && dfs(target / head, tail) }
    }
  }
}

fn dfs2(target: Int, parts: List(Int)) -> Bool {
  case parts {
    [] -> target == 0
    [t] -> target == t
    [head, ..tail] -> {
      dfs2(target - head, tail)
      || { target % head == 0 && dfs2(target / head, tail) }
      || {
        let ts = int.to_string(target)
        let hs = int.to_string(head)

        string.ends_with(ts, hs)
        && dfs2(
          string.drop_end(ts, string.length(hs))
            |> int.parse
            |> result.unwrap(-1),
          tail,
        )
      }
    }
  }
}

pub fn part1(s: String) {
  use eqs <- result.try(parse(s) |> result.replace_error("parse error"))
  eqs
  |> list.filter_map(fn(x) {
    let #(base, parts) = x
    case dfs(base, parts |> list.reverse) {
      True -> Ok(base)
      False -> Error(Nil)
    }
  })
  |> int.sum
  |> int.to_string
  |> Ok
}

pub fn part2(s: String) {
  use eqs <- result.try(parse(s) |> result.replace_error("parse error"))
  eqs
  |> list.filter_map(fn(x) {
    let #(base, parts) = x
    case dfs2(base, parts |> list.reverse) {
      True -> Ok(base)
      False -> Error(Nil)
    }
  })
  |> int.sum
  |> int.to_string
  |> Ok
}
