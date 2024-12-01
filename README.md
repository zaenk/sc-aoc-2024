# hello

[![Package Version](https://img.shields.io/hexpm/v/hello)](https://hex.pm/packages/hello)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/hello/)

```sh
gleam add hello@1
```
```gleam
import hello

pub fn main() {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/hello>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

Running only a single challange

```sh
gleam run -m aoc01
```

Measuring time and memory

```sh
export TIME='\t%E real\n\t%U user\n\t%S sys\n\t%K amem\n\t%M mmem'
/usr/bin/time gleam run -m aoc01
```