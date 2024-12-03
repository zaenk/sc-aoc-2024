import gleam/int
import gleam/io
import gleam/list
import gleam/string
import internal/files

pub fn main() {
  let readings = parse(files.read_file("data/02/part1.txt"))
  part1(readings)
  part2(readings)
}

pub fn parse(content: String) -> List(List(Int)) {
  string.split(content, "\n")
  |> list.map(parse_line)
}

pub fn parse_line(line: String) -> List(Int) {
  string.split(line, " ")
  |> list.filter_map(fn(x) { int.parse(x) })
}

fn part1(readings: List(List(Int))) {
  io.println("day 2 part 1")
  io.println(int.to_string(count_safe(readings)))
}

pub fn count_safe(readings: List(List(Int))) -> Int {
  list.map(readings, is_safe_reading)
  |> list.count(fn(is_safe) { is_safe == True })
}

type Direction {
  Ascending
  Descending
  Unkown
  Unsafe
}

fn is_safe_reading(readings: List(Int)) -> Bool {
  is_safe_reading_loop(readings, Unkown)
}

fn is_safe_reading_loop(readings: List(Int), dir: Direction) -> Bool {
  case dir {
    Unsafe -> False
    _ -> {
      case readings {
        [] | [_] -> {
          case dir {
            Unsafe | Unkown -> False
            Ascending | Descending -> True
          }
        }
        [curr, next, ..rest] -> {
          let new_dir = case curr - next {
            -3 | -2 | -1 -> Ascending
            1 | 2 | 3 -> Descending
            _ -> Unsafe
          }
          let next_dir = case dir, new_dir {
            Unkown, _ -> new_dir
            Ascending, Ascending -> Ascending
            Descending, Descending -> Descending
            _, _ -> Unsafe
          }
          is_safe_reading_loop([next, ..rest], next_dir)
        }
      }
    }
  }
}

fn part2(readings: List(List(Int))) {
  io.println("day 2 part 2")
  io.println(int.to_string(count_safe_damped(readings)))
}

pub fn count_safe_damped(readings: List(List(Int))) -> Int {
  list.map(readings, fn(r) {
    // io.debug(lists.to_string(r))
    let s = count_safe_damped_single(r)
    // io.debug(bool.to_string(s))
    s
  })
  |> list.count(fn(x) { x == True })
}

fn count_safe_damped_single(readings: List(Int)) -> Bool {
  count_safe_damped_loop([], [], readings)
}

fn count_safe_damped_loop(
  head: List(Int),
  damped: List(Int),
  tail: List(Int),
) -> Bool {
  case tail, damped {
    [], [] -> False
    _, _ -> {
      let curr_list = list.flatten([list.reverse(head), tail])
      case is_safe(curr_list) {
        True -> True
        False -> {
          let next_head = case damped {
            [] -> head
            [prev_damped] -> [prev_damped, ..head]
            _ -> panic as "not reachable state"
          }
          let #(next_damped, next_tail) = case tail {
            [] -> #([], [])
            [last] -> #([last], [])
            [last, ..rest] -> #([last], rest)
          }
          count_safe_damped_loop(next_head, next_damped, next_tail)
        }
      }
    }
  }
}

fn is_safe(readings: List(Int)) -> Bool {
  // io.println("is safe " <> lists.to_string(readings))
  case readings {
    [] -> False
    [_, ..tail] -> {
      let diffs =
        list.zip(readings, tail)
        |> list.map(fn(x) { x.0 - x.1 })
      is_monotonic_diffs(diffs) && is_safe_diffs(diffs)
    }
  }
}

fn is_monotonic_diffs(diffs: List(Int)) -> Bool {
  list.all(diffs, fn(x) { x > 0 }) || list.all(diffs, fn(x) { x < 0 })
}

fn is_safe_diffs(diffs: List(Int)) -> Bool {
  list.all(diffs, fn(x) {
    case int.absolute_value(x) {
      1 | 2 | 3 -> True
      _ -> False
    }
  })
}
