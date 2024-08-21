
use std log;
use ./handle.nu fexit;

export def can_execute [context: string, required: bool = false] {
  let search = which $context
  if (($search | length) == 0) {
    if ($required == true) {
      log error $"Please ensure 'git' is installed and available to the path.";
      fexit 1 "can_execute"
      return false;
    }
    return false;
  }
  return true;
}
