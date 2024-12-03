import aoc02
import gleeunit/should

const readings = [
  [7, 6, 4, 2, 1], [1, 2, 7, 8, 9], [9, 7, 6, 2, 1], [1, 3, 2, 4, 5],
  [8, 6, 4, 4, 1], [1, 3, 6, 7, 9],
]

const damping_safe = [
  [88, 86, 88, 89, 90, 93, 95], [85, 88, 86, 88, 89, 90, 93, 95],
]

pub fn safe_test() {
  aoc02.count_safe(readings)
  |> should.equal(2)
}

pub fn safe_damped_test() {
  aoc02.count_safe_damped(readings)
  |> should.equal(4)
}

pub fn safe_damped_by_dropping_first_test() {
  aoc02.count_safe_damped(damping_safe)
  |> should.equal(2)
}
