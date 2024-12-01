import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  io.debug("it works")
  read_file()
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

fn read_file() {
  let assert Ok(contents) = simplifile.read("data/01/part1.txt")
  let #(left, right) = read(contents, Left, "", [], [])
  // io.debug(list.length(left))
  // io.debug(list.length(right))
  io.debug(total_dist(left, right))
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
