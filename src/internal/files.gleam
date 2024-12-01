import simplifile

pub fn read_file(path: String) -> String {
  case simplifile.read(path) {
    Ok(content) -> content
    Error(error) ->
      panic as {
        "could not read file, reason: " <> simplifile.describe_error(error)
      }
  }
}
