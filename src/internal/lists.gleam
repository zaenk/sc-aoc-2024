import gleam/int
import gleam/list
import gleam/string

pub fn to_string(l: List(Int)) -> String {
  let ls =
    list.map(l, fn(x) { int.to_string(x) })
    |> list.fold("", fn(acc, x) { acc <> ", " <> x })
  "[" <> string.slice(ls, 2, string.length(ls)) <> "]"
}
