
use std log;

export def fexit [exit_code: int, id: string] {
  if ($exit_code != 0) {
    log error $"($id)|exit = ($exit_code); failed execution";
    exit $exit_code;
  }
  log info $"($id)|exit = 0; successful execution"
  exit 0;
}
