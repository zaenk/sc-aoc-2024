import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import internal/files

pub fn main() {
  let input = files.read_file("data/05/part1.txt")
  io.println("day 5 part 1")
  io.println(int.to_string(part1(input)))
  io.println("day 5 part 2")
  io.println(int.to_string(part2(input)))
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

pub fn part2(input: String) -> Int {
  let #(assignment, rules) = parse(string.split(input, "\n"))

  let fix_pages_with_rules = fn(x: List(Int)) { fix_pages(x, rules) }

  list.filter(assignment, fn(x) { !is_valid_pages(x, rules) })
  |> list.map(fix_pages_with_rules)
  |> list.map(pick_middle_element)
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

pub fn fix_pages(
  line: List(Int),
  rules: Dict(Int, #(List(Int), List(Int))),
) -> List(Int) {
  let fixed = case line {
    [head, ..tail] -> fix_pages_loop([], head, tail, rules)
    _ -> line
  }
  // io.debug(line)
  // io.debug(fixed)
  // io.debug("")
  fixed
}

fn fix_pages_loop(
  head: List(Int),
  item: Int,
  tail: List(Int),
  rules: Dict(Int, #(List(Int), List(Int))),
) -> List(Int) {
  case tail {
    [] -> list.reverse([item, ..head])
    _ -> {
      let #(correct, invalid, rest) = find_invalid(item, [], tail, rules)
      // io.debug(head)
      // io.debug(item)
      // io.debug(tail)
      // io.debug(correct)
      // io.debug(invalid)
      // io.debug(rest)
      // io.debug("")
      case invalid {
        [inv] ->
          // fix_pages_loop(
          //   [inv, ..head],
          //   item,
          //   list.flatten([correct, rest]),
          //   rules,
          // )
          fix_pages_loop(
            head,
            inv,
            list.flatten([[item], correct, rest]),
            rules,
          )
        _ -> {
          case tail {
            [next, ..rest] -> fix_pages_loop([item, ..head], next, rest, rules)
            [] -> panic as "not possible"
          }
        }
      }
    }
  }
}

fn find_invalid(
  item: Int,
  head: List(Int),
  tail: List(Int),
  rules: Dict(Int, #(List(Int), List(Int))),
) -> #(List(Int), List(Int), List(Int)) {
  case tail {
    [] -> #(list.reverse(head), [], [])
    [next, ..rest] -> {
      let #(after_item, _) = result.unwrap(dict.get(rules, next), #([], []))
      case list.find(after_item, fn(x) { x == item }) {
        Ok(_) -> #(list.reverse(head), [next], rest)
        Error(_) -> find_invalid(item, [next, ..head], rest, rules)
      }
    }
  }
}
