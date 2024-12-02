import gleam/int
import gleam/io
import gleam/list
import gleam/string
import internal/files

pub fn main() {
  part1()
}

fn part1() {
  io.println("day 2 part 1")
  let readings = parse(files.read_file("data/02/part1.txt"))
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

pub fn parse(content: String) -> List(List(Int)) {
  string.split(content, "\n")
  |> list.map(parse_line)
}

pub fn parse_line(line: String) -> List(Int) {
  string.split(line, " ")
  |> list.filter_map(fn(x) { int.parse(x) })
}
