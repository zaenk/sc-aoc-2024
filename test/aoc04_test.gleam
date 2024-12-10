import aoc04
import gleam/list
import gleeunit/should

const input = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"

pub fn word_search_test() {
  aoc04.part1(input)
  |> should.equal(18)
}

pub fn word_search_base_test() {
  aoc04.part1("MMMSXXMASM")
  |> should.equal(1)
}

const parts = [
  "
XMAS
....
....
....
",
  "
SAMX
....
....
....
",
  "
X...
M...
A...
S...
",
  "
S...
A...
M...
X...
",
  "
X...
.M..
..A.
...S
",
  "
S...
.A..
..M.
...X
",
  "
...X
..M.
.A..
S...
",
  "
...S
..A.
.M..
X...
",
]

pub fn word_search_parts_test() {
  list.each(parts, fn(part) {
    aoc04.part1(part)
    |> should.equal(1)
  })
}

const t_input = "abc
def
ghi"

const t_expected = "adg
beh
cfi"

pub fn transpose_test() {
  aoc04.transpose(t_input)
  |> should.equal(t_expected)
}

pub fn search_test() {
  aoc04.part1(
    "MAMXSXAMXMAXMAMXSSMSSSMAAXAMXAMSMMSSMXSAMMSXMAMAAAMAXSAMMXMASAAXMMSSMXXMASMSASXXSAMXSAMMMMXXXMAXXXMXSSXSAMXSMSMAAAMMXXMAXAXSXMASAMMSMMSSMMAS",
  )
  |> should.equal(5)
}

pub fn search2_test() {
  aoc04.part1("XMASXMAS")
  |> should.equal(2)
}
