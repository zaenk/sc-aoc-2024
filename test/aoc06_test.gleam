import aoc06
import gleeunit/should

const part1_input = "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"

const part1_route = "....#.....
....XXXXX#
....X...X.
..#.X...X.
..XXXXX#X.
..X.X.X.X.
.#XXXXXXX.
.XXXXXXX#.
#XXXXXXX..
......#X..
"

fn part1_test() {
  aoc06.part1(part1_input)
  |> should.equal(41)
}
