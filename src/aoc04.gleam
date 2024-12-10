import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import internal/files
import internal/strings

pub fn main() {
  let input = files.read_file("data/04/part1.txt")
  io.println("day 4 part 1")
  io.println(int.to_string(part1(input)))
  io.println("day 4 part 2")
  io.println(int.to_string(part2(input)))
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
  let res =
    string.split(input, "\n")
    |> list.filter(strings.not_empty)
    |> list.map(fn(line) { find_in_line(line, search, search, 0) })
    |> int.sum
  // io.println(search)
  // io.println(int.to_string(res))
  // io.println(input)
  // io.println("")
  res
}

fn find_vertical(input: String, search: String) -> Int {
  let s = transpose(input)
  find_horizontal(s, search)
}

pub fn transpose(input: String) -> String {
  let #(w, _) =
    string.split(input, "\n")
    |> list.filter(strings.not_empty)
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
      #(w, next_col)
    })
  list.map(w, fn(chars) { string.join(chars, "") })
  |> string.join("\n")
}

fn find_diagonal(input: String, search: String) -> Int {
  let lines =
    string.split(input, "\n")
    |> list.filter(strings.not_empty)
  let #(_, _, padded_lines) = pad_lines(lines, 0, 0)
  let padded_input = string.join(padded_lines, "\n")
  find_vertical(padded_input, search)
}

fn pad_lines(
  lines: List(String),
  lpad: Int,
  rpad: Int,
) -> #(Int, Int, List(String)) {
  case lines {
    [] -> panic as "not possible"
    [last] -> {
      let left = string.repeat("Z", lpad)
      let right = string.repeat("Z", rpad)
      let padded = string.concat([left, last, right])
      #(lpad + 1, rpad - 1, [padded])
    }
    [line, ..rest] -> {
      let #(lp, rp, padded_rest) = pad_lines(rest, lpad, rpad + 1)
      let left = string.repeat("Z", lp)
      let right = string.repeat("Z", rp)
      let padded = string.concat([left, line, right])
      #(lp + 1, rp - 1, [padded, ..padded_rest])
    }
  }
}

fn reverse_lines(input: String) -> String {
  string.split(input, "\n")
  |> list.filter(strings.not_empty)
  |> list.map(fn(line) { string.reverse(line) })
  |> string.join("\n")
}

fn find_in_line(
  line: String,
  search: String,
  orig_search: String,
  count: Int,
) -> Int {
  case string.first(search) {
    Ok(s) -> {
      case string.first(line) {
        // line run out
        Error(_) -> count
        Ok(c) -> {
          case s == c {
            True ->
              find_in_line(
                drop_first(line),
                drop_first(search),
                orig_search,
                count,
              )
            // char not matched
            False -> {
              case search == orig_search {
                True ->
                  find_in_line(
                    drop_first(line),
                    orig_search,
                    orig_search,
                    count,
                  )
                // DAMMIT
                False -> find_in_line(line, orig_search, orig_search, count)
              }
            }
          }
        }
      }
    }
    // search empty -> we found it
    Error(_) -> {
      case line {
        "" -> count + 1
        _ -> find_in_line(line, orig_search, orig_search, count + 1)
      }
    }
  }
}

fn drop_first(s: String) -> String {
  string.slice(s, 1, string.length(s))
}

pub fn part2(content: String) -> Int {
  let lines = string.split(content, "\n")
  count_x_mas(lines, 0)
}

fn count_x_mas(lines: List(String), count: Int) -> Int {
  case lines {
    [l1, l2, l3, ..rest] -> {
      let next_count = count_x_mas_in_lines(l1, l2, l3, count)
      count_x_mas(list.flatten([[l2], [l3], rest]), next_count)
    }
    _ -> {
      count
    }
  }
}

fn count_x_mas_in_lines(l1: String, l2: String, l3: String, count: Int) -> Int {
  case string.length(l1) {
    cnt if cnt < 3 -> count
    _ -> {
      case get_diagonals(l1, l2, l3) {
        Ok(#(d1, d2)) -> {
          let next_count = case d1, d2 {
            "MAS", "MAS" -> count + 1
            "MAS", "SAM" -> count + 1
            "SAM", "MAS" -> count + 1
            "SAM", "SAM" -> count + 1
            _, _ -> count
          }
          count_x_mas_in_lines(
            string.drop_start(l1, 1),
            string.drop_start(l2, 1),
            string.drop_start(l3, 1),
            next_count,
          )
        }
        _ -> {
          count
        }
      }
    }
  }
}

fn get_diagonals(
  l1: String,
  l2: String,
  l3: String,
) -> Result(#(String, String), Nil) {
  use #(a1, _, c1) <- result.try(get_first_3(l1))
  use #(_, b2, _) <- result.try(get_first_3(l2))
  use #(a3, _, c3) <- result.try(get_first_3(l3))
  let d1 = string.join([a1, b2, c3], "")
  let d2 = string.join([a3, b2, c1], "")
  Ok(#(d1, d2))
}

fn get_first_3(line: String) -> Result(#(String, String, String), Nil) {
  case string.length(line) {
    cnt if cnt >= 3 -> {
      use a1 <- result.try(string.first(line))
      use b1 <- result.try(string.first(string.drop_start(line, 1)))
      use c1 <- result.try(string.first(string.drop_start(line, 2)))
      Ok(#(a1, b1, c1))
    }
    _ -> Error(Nil)
  }
}
