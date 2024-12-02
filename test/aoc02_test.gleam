import aoc02
import gleeunit/should

const readings = [
  [7, 6, 4, 2, 1], [1, 2, 7, 8, 9], [9, 7, 6, 2, 1], [1, 3, 2, 4, 5],
  [8, 6, 4, 4, 1], [1, 3, 6, 7, 9],
]

pub fn safe_test() {
  aoc02.count_safe(readings)
  |> should.equal(2)
}
