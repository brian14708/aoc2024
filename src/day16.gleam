import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/order
import gleam/set
import gleam/string
import gleamy/priority_queue as pq

type Direction {
  North
  East
  South
  West
}

type Maze {
  Maze(
    map: set.Set(#(Int, Int)),
    start: #(Int, Int, Direction),
    end: #(Int, Int),
  )
}

fn parse(map: String) -> Maze {
  map
  |> string.split("\n")
  |> list.index_fold(
    Maze(map: set.new(), start: #(-1, -1, East), end: #(-1, -1)),
    fn(acc, line, i) {
      line
      |> string.to_graphemes
      |> list.index_fold(acc, fn(acc, v, j) {
        case v {
          "#" ->
            Maze(
              map: set.insert(acc.map, #(i, j)),
              start: acc.start,
              end: acc.end,
            )
          "S" -> Maze(map: acc.map, start: #(i, j, East), end: acc.end)
          "E" -> Maze(map: acc.map, start: acc.start, end: #(i, j))
          _ -> acc
        }
      })
    },
  )
}

type Entry {
  Entry(
    position: #(Int, Int),
    from: option.Option(#(#(Int, Int), Direction)),
    direction: Direction,
    score: Int,
  )
}

fn clockwise(d: Direction) -> Direction {
  case d {
    North -> East
    East -> South
    South -> West
    West -> North
  }
}

fn step(
  q: pq.Queue(Entry),
  maze: set.Set(#(Int, Int)),
  end: #(Int, Int),
  visited: dict.Dict(
    #(#(Int, Int), Direction),
    #(Int, List(#(#(Int, Int), Direction))),
  ),
) -> #(
  Int,
  dict.Dict(#(#(Int, Int), Direction), #(Int, List(#(#(Int, Int), Direction)))),
) {
  let assert Ok(#(v, q)) = pq.pop(q)
  let d = dict.has_key(visited, #(v.position, v.direction))
  let visited =
    dict.upsert(visited, #(v.position, v.direction), fn(s) {
      case s, v.from {
        _, option.None -> #(v.score, [])
        option.Some(#(score, sources)), option.Some(f) ->
          case int.compare(score, v.score) {
            order.Eq -> #(score, list.append(sources, [f]))
            order.Gt -> #(v.score, [f])
            order.Lt -> #(score, sources)
          }
        option.None, option.Some(f) -> #(v.score, [f])
      }
    })
  use <- bool.guard(v.position == end, #(v.score, visited))
  use <- bool.lazy_guard(d, fn() { step(q, maze, end, visited) })

  [
    #(v.direction, 0),
    #(clockwise(v.direction), 1000),
    #(clockwise(clockwise(v.direction)), 2000),
    #(clockwise(clockwise(clockwise(v.direction))), 1000),
  ]
  |> list.fold(q, fn(q, a) {
    let p = case a.0 {
      North -> #(v.position.0 - 1, v.position.1)
      East -> #(v.position.0, v.position.1 + 1)
      South -> #(v.position.0 + 1, v.position.1)
      West -> #(v.position.0, v.position.1 - 1)
    }
    case set.contains(maze, p) {
      True -> q
      False ->
        pq.push(
          q,
          Entry(
            p,
            option.Some(#(v.position, v.direction)),
            a.0,
            v.score + a.1 + 1,
          ),
        )
    }
  })
  |> step(maze, end, visited)
}

fn solve(maze: Maze) -> Int {
  let q =
    pq.new(fn(a: Entry, b) { int.compare(a.score, b.score) })
    |> pq.push(Entry(
      #(maze.start.0, maze.start.1),
      option.None,
      maze.start.2,
      0,
    ))
  let #(score, _) = step(q, maze.map, maze.end, dict.new())
  score
}

pub fn part1(s: String) -> Result(String, String) {
  s |> parse |> solve |> int.to_string |> Ok
}

fn count_impl(
  visited: dict.Dict(
    #(#(Int, Int), Direction),
    #(Int, List(#(#(Int, Int), Direction))),
  ),
  position: #(#(Int, Int), Direction),
  result: set.Set(#(Int, Int)),
) -> set.Set(#(Int, Int)) {
  let v = set.insert(result, position.0)
  case dict.get(visited, position) {
    Ok(#(_, sources)) ->
      list.fold(sources, v, fn(v, s) { count_impl(visited, s, v) })
    _ -> v
  }
}

fn count(
  visited: dict.Dict(
    #(#(Int, Int), Direction),
    #(Int, List(#(#(Int, Int), Direction))),
  ),
  position: #(Int, Int),
) -> set.Set(#(Int, Int)) {
  [North, East, South, West]
  |> list.map(fn(d) { #(position, d) })
  |> list.fold(set.new(), fn(v, s) { count_impl(visited, s, v) })
}

pub fn part2(s: String) -> Result(String, String) {
  let maze = s |> parse
  let q =
    pq.new(fn(a: Entry, b) { int.compare(a.score, b.score) })
    |> pq.push(Entry(
      #(maze.start.0, maze.start.1),
      option.None,
      maze.start.2,
      0,
    ))
  let #(_, visited) = step(q, maze.map, maze.end, dict.new())
  visited
  |> count(maze.end)
  |> set.size
  |> int.to_string
  |> Ok
}
