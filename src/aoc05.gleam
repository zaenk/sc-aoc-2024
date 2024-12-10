import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import internal/files
import internal/strings

pub fn main() {
  let input = files.read_file("data/05/part1.txt")
  io.println("day 5 part 1")
  io.println(int.to_string(part1(input)))
  // io.println("day 5 part 2")
  // io.println(int.to_string(part2(input)))
}

type Rule {
  Rule(page: Int, pages_before: List(Int), pages_after: List(Int))
}

pub fn part1(input: String) -> Int {
  let #(assignment, rules) = parse(string.split(input, "\n"))
  list.map(assignment, fn(x) {
    case is_valid_pages(x, rules) {
      True -> pick_middle_element(x)
      False -> 0
    }
  })
  |> int.sum
}

fn parse(
  lines: List(String),
) -> #(List(List(Int)), Dict(Int, #(List(Int), List(Int)))) {
  let #(rule_lines, assignment_lines) =
    list.filter(lines, fn(l) { l != "" })
    |> list.partition(fn(l) { string.contains(l, "|") })

  #(parse_assignment(assignment_lines), parse_rules(rule_lines))
}

fn parse_rules(lines: List(String)) -> Dict(Int, #(List(Int), List(Int))) {
  list.map(lines, fn(line) {
    let assert [s1, s2, ..] = string.split(line, "|")
    use p1 <- result.try(int.parse(s1))
    use p2 <- result.try(int.parse(s2))
    Ok(#(p1, p2))
  })
  |> list.filter(result.is_ok)
  |> list.map(fn(x) { result.unwrap(x, #(-1, -1)) })
  |> list.fold(
    dict.new(),
    fn(rules: Dict(Int, #(List(Int), List(Int))), rule: #(Int, Int)) {
      let #(page, before_page) = rule
      dict.upsert(rules, page, fn(current_rule) {
        case current_rule {
          Some(pages) -> #([before_page, ..pages.0], pages.1)
          None -> #([before_page], [])
        }
      })
      |> dict.upsert(before_page, fn(current_rule) {
        case current_rule {
          Some(pages) -> #(pages.0, [page, ..pages.1])
          None -> #([], [page])
        }
      })
    },
  )
}

fn parse_assignment(lines: List(String)) -> List(List(Int)) {
  list.map(lines, fn(x) {
    let nums = string.split(x, ",")
    list.map(nums, fn(n) { int.parse(n) })
    |> list.filter(result.is_ok)
    |> list.map(fn(x) { result.unwrap(x, -1) })
  })
}

fn pick_middle_element(line: List(Int)) -> Int {
  let size = list.length(line)
  let index = result.unwrap(int.floor_divide(size, 2), -1)
  list.drop(line, index)
  |> list.first
  |> result.unwrap(-1)
}

fn is_valid_pages(
  line: List(Int),
  rules: Dict(Int, #(List(Int), List(Int))),
) -> Bool {
  case line {
    [head, ..tail] -> is_valid_pages_loop(head, tail, rules, True)
    _ -> True
  }
}

fn is_valid_pages_loop(
  item: Int,
  tail: List(Int),
  rules: Dict(Int, #(List(Int), List(Int))),
  is_valid: Bool,
) -> Bool {
  case is_valid {
    False -> False
    True -> {
      let valid =
        list.map(tail, fn(tail_i) {
          let #(after_item, _) =
            result.unwrap(dict.get(rules, tail_i), #([], []))
          list.filter(after_item, fn(x) { x == item })
          |> list.is_empty
        })
        |> list.all(fn(x) { x == True })
      case tail {
        [] -> valid
        [next, ..rest] -> is_valid_pages_loop(next, rest, rules, valid)
      }
    }
  }
}
