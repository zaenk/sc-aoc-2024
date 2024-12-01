import gleam/io

pub fn main() {
  io.println("Hello from hello!")
  io.debug(fib(30))
}

fn fib(n: Int) -> Int {
  case n {
    0 -> 0
    1 -> 1
    _ -> fib(n - 1) + fib(n - 2)
  }
}
