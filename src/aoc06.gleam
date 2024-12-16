import gleam/int
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/result
import internal/files

pub fn main() {
  let input = files.read_file("data/05/part1.txt")
  io.println("day 6 part 1")
  io.println(int.to_string(part1(input)))
}

pub fn part1(input: String) {
  todo
}

const up = "^"

const down = "v"

const left = "<"

const right = ">"

const obstacle = "#"

const empty = "."

const visited = "X"

fn turn_right(dir: String) -> String {
  case dir {
    "^" -> right
    ">" -> down
    "v" -> left
    "<" -> up
    _ -> panic as { "invlid direction: " <> dir }
  }
}

type Position {
  Position(
    center: String,
    north: String,
    east: String,
    south: String,
    west: String,
  )
}

fn move(pos: Position) -> Position {
  todo
}

fn move_up(pos: Position) -> Position {
  case pos.north {
    // obstacle, turn right
    "#" -> Position(..pos, center: turn_right(pos.center))
    // edge of map, exit
    "" -> Position(..pos, center: visited)
    // walking
    "." | "X" -> Position(..pos, center: visited, north: up)
    _ -> panic as { "invalid target: " <> pos.north }
  }
}

fn move_right(pos: Position) -> Position {
  case pos.east {
    // obstacle, turn right
    "#" -> Position(..pos, center: turn_right(pos.center))
    // edge of map, exit
    "" -> Position(..pos, center: visited)
    // walking
    "." | "X" -> Position(..pos, center: visited, east: right)
    _ -> panic as { "invalid target: " <> pos.east }
  }
}

fn move_down(pos: Position) -> Position {
  case pos.south {
    // obstacle, turn right
    "#" -> Position(..pos, center: turn_right(pos.center))
    // edge of map, exit
    "" -> Position(..pos, center: visited)
    // walking
    "." | "X" -> Position(..pos, center: visited, south: down)
    _ -> panic as { "invalid target: " <> pos.south }
  }
}

fn move_left(pos: Position) -> Position {
  case pos.west {
    // obstacle, turn right
    "#" -> Position(..pos, center: turn_right(pos.center))
    // edge of map, exit
    "" -> Position(..pos, center: visited)
    // walking
    "." | "X" -> Position(..pos, center: visited, west: left)
    _ -> panic as { "invalid target: " <> pos.west }
  }
}

fn find_move_in_grid(
  grid: List(List(String)),
) -> Option(fn(Position) -> Position) {
  case grid {
    [] -> None
    [head, ..tail] -> {
      let move = find_move_in_line(head)
      case move {
        Some(_) -> move
        None -> find_move_in_grid(tail)
      }
    }
  }
}

fn find_move_in_line(line: List(String)) -> Option(fn(Position) -> Position) {
  case line {
    [] -> None
    [head, ..tail] -> {
      let move = find_move(head)
      case move {
        Some(_) -> move
        None -> find_move_in_line(tail)
      }
    }
  }
}

fn find_move(char: String) -> Option(fn(Position) -> Position) {
  case char {
    "^" -> Some(move_up)
    ">" -> Some(move_right)
    "v" -> Some(move_down)
    "<" -> Some(move_left)
    _ -> None
  }
}
