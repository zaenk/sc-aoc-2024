import gleam/int
import gleam/io
import gleam/list
import gleam/string
import internal/files

pub fn main() {
  let input = files.read_file("data/04/part1.txt")
  io.debug("day 4 part 1")
  io.debug(part1(input))
}

const word = "XMAS"

pub fn part1(input: String) -> Int {
  let word_reverse = string.reverse(word)
  find_horizontal(input, word)
  + find_horizontal(input, word_reverse)
  + find_vertical(input, word)
  + find_vertical(input, word_reverse)
  + find_diagonal(input, word)
  + find_diagonal(input, word_reverse)
  + find_diagonal(reverse_lines(input), word)
  + find_diagonal(reverse_lines(input), word_reverse)
}

fn find_horizontal(input: String, search: String) -> Int {
  io.debug(search)
  string.split(input, "\n")
  |> list.filter(fn(x) { x != "" })
  |> list.map(fn(line) {
    io.debug(line)
    let c = find_in_line(line, search, 0)
    io.debug(c)
    c
  })
  |> int.sum
}

fn find_vertical(input: String, search: String) -> Int {
  let s = transpose(input)
  io.println("input")
  io.println(s)
  find_horizontal(s, search)
}

pub fn transpose(input: String) -> String {
  let #(w, _) =
    string.split(input, "\n")
    |> list.filter(fn(x) { x != "" })
    |> list.map_fold([[]], fn(cols: List(List(String)), line) {
      let next_col =
        string.to_graphemes(line)
        |> list.map(fn(x) { [x] })
      let w = case cols {
        [[]] -> next_col
        _ -> {
          list.zip(cols, next_col)
          |> list.map(fn(x) {
            let #(col, next) = x
            list.append(col, next)
          })
        }
      }
      io.debug(next_col)
      io.debug(w)
      #(w, next_col)
    })
  list.map(w, fn(chars) { string.join(chars, "") })
  |> string.join("\n")
}

fn find_diagonal(input: String, search: String) -> Int {
  0
}

fn reverse_lines(input: String) -> String {
  string.split(input, "\n")
  |> list.filter(fn(x) { x != "" })
  |> list.map(fn(line) { string.reverse(line) })
  |> string.join("\n")
}

fn find_in_line(line: String, search: String, count: Int) -> Int {
  io.debug(line)
  io.debug(search)
  io.debug(count)
  case string.first(search) {
    Ok(s) -> {
      case string.first(line) {
        // line run out
        Error(_) -> count
        Ok(c) -> {
          case s == c {
            True -> find_in_line(drop_first(line), drop_first(search), count)
            // char not matched
            False -> count
          }
        }
      }
    }
    // search empty -> we found it
    Error(_) -> {
      case line {
        "" -> count + 1
        _ -> find_in_line(drop_first(line), drop_first(search), count + 1)
      }
    }
  }
}

fn drop_first(s: String) -> String {
  string.slice(s, 1, string.length(s))
}
