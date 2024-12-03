import aoc03
import gleeunit/should

const input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

pub fn part1_test() {
  aoc03.solve_part1(input)
  |> should.equal(161)
}
