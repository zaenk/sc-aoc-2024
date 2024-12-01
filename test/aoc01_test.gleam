import aoc01
import gleeunit/should

const left = [3, 4, 2, 1, 3, 3]

const right = [4, 3, 5, 3, 9, 3]

pub fn total_dist_test() {
  aoc01.total_dist(left, right)
  |> should.equal(11)
}

pub fn similarity_test() {
  aoc01.similarity(left, right)
  |> should.equal(31)
}
