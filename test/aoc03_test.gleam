import aoc03
import gleeunit/should

const input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

pub fn part1_test() {
  aoc03.solve_part1(input)
  |> should.equal(161)
}

const input2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

pub fn part2_test() {
  aoc03.solve_part2(input2)
  |> should.equal(48)
}
