import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import internal/files

pub fn main() {
  io.debug("aoc 2024 day 1")
  let #(left, right) = parse_assignment()
  part1(left, right)
  part2(left, right)
}

fn parse_assignment() -> #(List(Int), List(Int)) {
  let contents = files.read_file("data/01/part1.txt")
  read(contents, Left, "", [], [])
}

fn part1(left: List(Int), right: List(Int)) {
  // io.debug(list.length(left))
  // io.debug(list.length(right))
  io.println("part 1: " <> int.to_string(total_dist(left, right)))
}

pub fn total_dist(left: List(Int), right: List(Int)) -> Int {
  let left = list.sort(left, int.compare)
  let right = list.sort(right, int.compare)
  list.zip(left, right)
  |> list.map(dist)
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
}

fn dist(pair: #(Int, Int)) -> Int {
  int.absolute_value(pair.0 - pair.1)
}

fn part2(left: List(Int), right: List(Int)) {
  // io.debug(list.length(left))
  // io.debug(list.length(right))
  io.println("part 2: " <> int.to_string(similarity(left, right)))
}

pub fn similarity(left: List(Int), right: List(Int)) -> Int {
  let left_d = count_unique(left, dict.new())
  let right_d = count_unique(right, dict.new())
  // io.debug(left_d)
  // io.debug(right_d)
  let res =
    dict.map_values(left_d, fn(l_number, l_count) {
      let r_count = case dict.get(right_d, l_number) {
        Ok(v) -> v
        Error(_) -> 0
      }
      l_number * r_count * l_count
    })
    |> dict.values
    |> list.reduce(fn(acc, x) { acc + x })
  case res {
    Ok(v) -> v
    Error(_) -> panic as "could not compute"
  }
}

fn count_unique(input: List(Int), counts: Dict(Int, Int)) -> Dict(Int, Int) {
  case input {
    [] -> counts
    [next, ..rest] -> {
      let inc = fn(x) {
        case x {
          Some(val) -> val + 1
          None -> 1
        }
      }
      let updated = dict.upsert(counts, next, inc)
      count_unique(rest, updated)
    }
  }
}

type State {
  Left
  Right
}

fn read(
  content: String,
  state: State,
  buf: String,
  left: List(Int),
  right: List(Int),
) -> #(List(Int), List(Int)) {
  case string.length(content) {
    0 -> #(list.reverse(left), list.reverse(right))
    _ -> {
      let ch = string.slice(content, 0, 1)
      let #(curr_buf, next_state) = case ch {
        "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> {
          #(buf <> ch, state)
        }
        " " -> {
          #(buf, Right)
        }
        "\n" -> {
          #(buf, Left)
        }
        _ -> {
          panic as "invalid character"
        }
      }
      let #(next_buf, next_left, next_right) = case state, next_state {
        Left, Right -> {
          let assert Ok(v) = int.parse(curr_buf)
          #("", [v, ..left], right)
        }
        Right, Left -> {
          let assert Ok(v) = int.parse(curr_buf)
          #("", left, [v, ..right])
        }
        _, _ -> #(curr_buf, left, right)
      }
      read(
        string.slice(content, 1, string.length(content)),
        next_state,
        next_buf,
        next_left,
        next_right,
      )
    }
  }
}
