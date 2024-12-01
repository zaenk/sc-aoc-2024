import aoc01
import gleeunit/should

pub fn total_dist_test() {
  let left = [3, 4, 2, 1, 3, 3]
  let right = [4, 3, 5, 3, 9, 3]
  aoc01.total_dist(left, right)
  |> should.equal(11)
}
