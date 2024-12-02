import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/order.{Gt, Lt}
import gleam/string
import internal/files
import internal/lists

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
    let s = count_safe_damped_loop(r, list.new(), Unkown, True, False)
    io.println(lists.to_string(r))
    io.println(bool.to_string(s))
    s
  })
  |> list.count(fn(x) { x == True })
}

fn count_safe_damped_loop(
  readings: List(Int),
  processed: List(Int),
  dir: Direction,
  is_safe: Bool,
  is_damped: Bool,
) -> Bool {
  case readings {
    [] -> False
    [_] -> is_safe
    [a, b] -> {
      let is_safe_damped = is_safe_reading_damped(a, b, dir, get_dir(a, b))
      is_safe && is_safe_damped || !is_damped
    }
    [a, b, c, ..rest] -> {
      let curr_dir = get_dir(a, b)
      let is_safe = is_safe_reading_damped(a, b, dir, curr_dir)
      case is_safe {
        True -> {
          count_safe_damped_loop(
            [b, c, ..rest],
            [a, ..processed],
            curr_dir,
            is_safe,
            is_damped,
          )
        }
        False -> {
          case is_damped {
            True -> False
            False -> {
              let curr_dir = get_dir(a, c)
              let is_safe_damped = is_safe_reading_damped(a, c, dir, curr_dir)
              case is_safe_damped {
                True -> {
                  count_safe_damped_loop(
                    [c, ..rest],
                    [a, ..processed],
                    curr_dir,
                    is_safe_damped,
                    True,
                  )
                }
                False -> {
                  let curr_dir = get_dir(b, c)
                  let is_safe_damped =
                    is_safe_reading_damped(b, c, dir, curr_dir)
                  let remains_safe = case processed {
                    [] -> True
                    [tail, ..] -> {
                      is_safe_reading_damped(tail, b, dir, get_dir(tail, b))
                    }
                  }
                  case is_safe_damped && remains_safe {
                    True -> {
                      count_safe_damped_loop(
                        [c, ..rest],
                        [b, ..processed],
                        curr_dir,
                        is_safe_damped,
                        True,
                      )
                    }
                    False -> False
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

fn is_safe_reading_damped(
  a: Int,
  b: Int,
  prev_dir: Direction,
  curr_dir: Direction,
) -> Bool {
  is_safe_diff(a, b) && is_safe_dir(prev_dir, curr_dir)
}

fn is_safe_diff(a: Int, b: Int) -> Bool {
  case int.absolute_value(a - b) {
    1 | 2 | 3 -> True
    _ -> False
  }
}

fn is_safe_dir(prev_dir: Direction, curr_dir: Direction) -> Bool {
  case prev_dir, curr_dir {
    Ascending, Ascending -> True
    Descending, Descending -> True
    Unkown, _ -> True
    _, _ -> False
  }
}

fn get_dir(a: Int, b: Int) -> Direction {
  case int.compare(a, b) {
    Gt -> Descending
    Lt -> Ascending
    _ -> Unkown
  }
}
