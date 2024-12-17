import gleam/dict
import gleam/int
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string

type Combo {
  Literal(Int)
  RegisterA
  RegisterB
  RegisterC
  Reserved
}

fn parse_combo(s: Int) -> Combo {
  case s {
    0 -> Literal(0)
    1 -> Literal(1)
    2 -> Literal(2)
    3 -> Literal(3)
    4 -> RegisterA
    5 -> RegisterB
    6 -> RegisterC
    _ -> Reserved
  }
}

type Instruction {
  Adv(Combo)
  Bxl(Int)
  Bst(Combo)
  Jnz(Int)
  Bxc
  Out(Combo)
  Bdv(Combo)
  Cdv(Combo)
}

fn parse_instruction(p: #(Int, Int)) -> Result(Instruction, Nil) {
  case p.0 {
    0 -> Ok(Adv(parse_combo(p.1)))
    1 -> Ok(Bxl(p.1))
    2 -> Ok(Bst(parse_combo(p.1)))
    3 -> Ok(Jnz(p.1))
    4 -> Ok(Bxc)
    5 -> Ok(Out(parse_combo(p.1)))
    6 -> Ok(Bdv(parse_combo(p.1)))
    7 -> Ok(Cdv(parse_combo(p.1)))
    _ -> Error(Nil)
  }
}

fn parse(s: String) -> #(Int, Int, Int, List(Int)) {
  let assert Ok(re) = regexp.from_string("[0-9]+")
  let assert [x, y] = s |> string.split("\n\n")
  let assert Ok([a, b, c]) =
    regexp.scan(re, x)
    |> list.try_map(fn(x) { int.parse(x.content) })
  let assert Ok(instruction) =
    regexp.scan(re, y)
    |> list.try_map(fn(x) { int.parse(x.content) })
  #(a, b, c, instruction)
}

fn exec(
  a: Int,
  b: Int,
  c: Int,
  instructions: dict.Dict(Int, Int),
  pc: Int,
  acc: List(Int),
) -> List(Int) {
  let i =
    dict.get(instructions, pc)
    |> result.then(fn(x) {
      dict.get(instructions, pc + 1)
      |> result.then(fn(y) { parse_instruction(#(x, y)) })
    })
  case i {
    Error(_) -> acc
    Ok(Adv(v)) -> {
      let v = case v {
        Literal(x) -> x
        RegisterA -> a
        RegisterB -> b
        RegisterC -> c
        Reserved -> 0
      }
      exec(
        { a / int.bitwise_shift_left(1, v) },
        b,
        c,
        instructions,
        pc + 2,
        acc,
      )
    }
    Ok(Bdv(v)) -> {
      let v = case v {
        Literal(x) -> x
        RegisterA -> a
        RegisterB -> b
        RegisterC -> c
        Reserved -> 0
      }
      exec(
        a,
        { a / int.bitwise_shift_left(1, v) },
        c,
        instructions,
        pc + 2,
        acc,
      )
    }
    Ok(Bst(v)) -> {
      let v = case v {
        Literal(x) -> x
        RegisterA -> a
        RegisterB -> b
        RegisterC -> c
        Reserved -> 0
      }
      exec(a, v % 8, c, instructions, pc + 2, acc)
    }
    Ok(Bxc) ->
      exec(a, int.bitwise_exclusive_or(b, c), c, instructions, pc + 2, acc)
    Ok(Bxl(l)) ->
      exec(a, int.bitwise_exclusive_or(l, b), c, instructions, pc + 2, acc)
    Ok(Cdv(v)) -> {
      let v = case v {
        Literal(x) -> x
        RegisterA -> a
        RegisterB -> b
        RegisterC -> c
        Reserved -> 0
      }
      exec(
        a,
        b,
        { a / int.bitwise_shift_left(1, v) },
        instructions,
        pc + 2,
        acc,
      )
    }
    Ok(Jnz(inst)) -> {
      case a {
        0 -> exec(a, b, c, instructions, pc + 2, acc)
        _ -> exec(a, b, c, instructions, inst, acc)
      }
    }
    Ok(Out(v)) -> {
      let v = case v {
        Literal(x) -> x
        RegisterA -> a
        RegisterB -> b
        RegisterC -> c
        Reserved -> 0
      }
      exec(a, b, c, instructions, pc + 2, list.append(acc, [v % 8]))
    }
  }
}

fn run(a: Int, b: Int, c: Int, instructions: dict.Dict(Int, Int)) -> List(Int) {
  exec(a, b, c, instructions, 0, [])
}

pub fn part1(s: String) -> Result(String, String) {
  let #(a, b, c, inst) = parse(s)
  Ok(
    run(
      a,
      b,
      c,
      inst
        |> list.index_fold(dict.new(), fn(d, x, i) { dict.insert(d, i, x) }),
    )
    |> list.map(int.to_string)
    |> string.join(","),
  )
}

fn search(
  a: Int,
  b: Int,
  c: Int,
  rev_target: List(Int),
  instructions: dict.Dict(Int, Int),
) -> Int {
  let assert Ok(n) =
    list.range(0, 63)
    |> list.find(fn(n) {
      rev_target == run(a * 8 + n, b, c, instructions) |> list.reverse
    })
  a * 8 + n
}

pub fn part2(s: String) -> Result(String, String) {
  let #(_, b, c, inst) = parse(s)
  let dinst =
    inst
    |> list.index_fold(dict.new(), fn(d, x, i) { dict.insert(d, i, x) })
  let rev_target = inst |> list.reverse
  list.range(1, list.length(rev_target))
  |> list.fold(0, fn(a, n) {
    search(a, b, c, rev_target |> list.take(n), dinst)
  })
  |> int.to_string
  |> Ok
}
