import aoc04
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
