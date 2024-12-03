import gleam/int
import gleam/io
import gleam/list
import gleam/string
import internal/files

pub fn main() {
  let input = files.read_file("data/03/part1.txt")
  part1(input)
  part2(input)
}

fn part1(input: String) {
  io.println("day 3 part 1")
  io.println(int.to_string(solve_part1(input)))
}

pub fn solve_part1(input) -> Int {
  let terms = parse(input, [])
  io.debug(terms)
  list.map(terms, fn(t) {
    case t {
      Term(_, a, b) -> a * b
      _ -> 0
    }
  })
  |> int.sum
}

fn part2(input: String) {
  io.println("day 3 part 2")
  io.println(int.to_string(solve_part2(input)))
}

pub fn solve_part2(input) -> Int {
  let terms = parse(input, [])
  io.debug(terms)
  let folded =
    list.reverse(terms)
    |> list.map_fold(DO, fn(mod, item) {
      case item {
        Term(_, a, b) -> {
          case mod {
            DO -> #(mod, a * b)
            DONT -> #(mod, 0)
            MUL -> panic as "not possible acc"
          }
        }
        Unary(DO) -> #(DO, 0)
        Unary(DONT) -> #(DONT, 0)
        Unary(MUL) -> panic as "not possible op"
      }
    })
  int.sum(folded.1)
}

type Term {
  Term(Operator, Int, Int)
  Unary(Operator)
}

type Operator {
  MUL
  DO
  DONT
}

fn parse(input: String, terms: List(Term)) -> List(Term) {
  // io.debug("parsing " <> input)
  case string.first(input) {
    Error(_) -> terms
    Ok(first) -> {
      case first {
        "m" -> {
          let op = string.slice(input, 0, 4)
          let operands = case op {
            "mul(" ->
              parse_operands(string.slice(input, 4, string.length(input)))
            _ -> Error("not an operator: " <> op)
          }
          case operands {
            Ok(#(op1, op2, rest)) -> parse(rest, [Term(MUL, op1, op2), ..terms])
            Error(_) ->
              parse(string.slice(input, 1, string.length(input)), terms)
          }
        }
        "d" -> {
          let do = string.starts_with(input, "do()")
          let dont = string.starts_with(input, "don't()")
          case do, dont {
            True, False ->
              parse(string.slice(input, 4, string.length(input)), [
                Unary(DO),
                ..terms
              ])
            False, True ->
              parse(string.slice(input, 7, string.length(input)), [
                Unary(DONT),
                ..terms
              ])
            _, _ -> parse(string.slice(input, 1, string.length(input)), terms)
          }
        }
        _ -> parse(string.slice(input, 1, string.length(input)), terms)
      }
    }
  }
}

fn parse_operands(input: String) -> Result(#(Int, Int, String), String) {
  case parse_digit(input, ",") {
    Ok(op1_res) -> {
      let #(op1, rest) = op1_res
      case parse_digit(rest, ")") {
        Ok(op2_res) -> {
          let #(op2, rest) = op2_res
          case int.parse(op1), int.parse(op2) {
            Ok(op1), Ok(op2) -> Ok(#(op1, op2, rest))
            _, _ -> Error("could not parse operators")
          }
        }
        Error(asd) -> Error(asd)
      }
    }
    Error(asd) -> Error(asd)
  }
}

fn parse_digit(
  input: String,
  delimiter: String,
) -> Result(#(String, String), String) {
  case string.first(input) {
    Error(_) -> Error("no more chars")
    Ok(s) if s == delimiter ->
      Ok(#("", string.slice(input, 1, string.length(input))))
    Ok(char) -> {
      case char {
        "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> {
          let next_digit =
            parse_digit(string.slice(input, 1, string.length(input)), delimiter)
          case next_digit {
            Ok(#(digit, rest)) -> Ok(#(char <> digit, rest))
            Error(_) -> Error("invalid number literal")
          }
        }
        _ -> Error("incomplete operand")
      }
    }
  }
}
