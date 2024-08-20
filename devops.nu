#!/usr/bin/env nu
# devops.nu

use std log

# Setup
def "main setup" [] {
  # Check for Updates
  check_update;

  # Configure Base
  gitignore;
  blank "stage-1" "validate";
  blank "stage-2" "build";
  blank "stage-99" "ci";

  # Prepare Git Dev State
  hook "pre-commit";
  git config core.hooksPath "./devops/git-hooks";
}

# Upgrade
def "main upgrade" [] {
  if ($env.PWD | str ends-with 'Base') {
    log warning $"task[setup]|Local guard triggered. This is the origin of devops.nu and upgrade should not be called here.";
  } else {
    http get "https://raw.githubusercontent.com/xCykrix/Base/main/devops.nu" | save -fp "devops.nu";
  }
}

def "main validate" [] {
  log info $"task[validate]|start = stage-1.nu";
  nu "./devops/stage-1.nu";
  let exit_code: int = $env.LAST_EXIT_CODE;
  handle_exit $exit_code "validate";
}

def "main build" [] {
  log info $"task[build]|start = stage-2.nu";
  nu "./devops/stage-2.nu";
  let exit_code: int = $env.LAST_EXIT_CODE;
  handle_exit $exit_code "build";
}

def "main ci" [] {
  log info $"task[ci]|start = stage-99.nu";
  nu "./devops/stage-99.nu";
  let exit_code: int = $env.LAST_EXIT_CODE;
  handle_exit $exit_code "ci";
}

# Functs
def handle_exit [exit_code: int, id: string] {
  if ($exit_code != 0) {
    log error $"task[($id)]|failed to execute task with exit code of ($exit_code)";
    exit $exit_code;
  }
  exit 0;
}

# Check for Updates with Caching
def check_update [] {
  mkdir devops;
  let current_hash: string = (open "./devops.nu" | hash sha256 | into string);
  mut refresh_hash = "TO_BE_CALCULATED";
  if (($"./devops/.update-cache" | path exists) and ((ls $"./devops/.update-cache" | get 0.modified) > ((date now) - 15min))) {
    $refresh_hash = (open "./devops/.update-cache" | into string);
  } else {
    $refresh_hash = (http get "https://raw.githubusercontent.com/xCykrix/Base/main/devops.nu" | hash sha256 | into string);
    $refresh_hash | save -fp $"./devops/.update-cache";
  }
  if ($current_hash != $refresh_hash) {
    log warning $"task[setup]|An update to base devops tooling is available. please run 'nu ./devops.nu upgrade' to install.";
  }
}

# Create .gitignore File for devops
def gitignore [] {
  mkdir devops;
  let exists = $"./devops/.gitignore" | path exists;
  if ($exists == false) {
    [
      $".update-cache"
    ] | str join "\n" | save -fp $"./devops/.gitignore";
  }
}

# Create Blank Script File with Comment
def blank [name: string, comment: string] {
  mkdir devops;
  let exists = $"./devops/($name).nu" | path exists;
  if ($exists == false) {
    [
      $"#!/usr/bin/env nu",
      $"# ($name).nu",
      "",
      $"print \"($name).nu - ($comment)\""
    ] | str join "\n" | save -fp $"./devops/($name).nu";
  }
}

# Create Blank Hook
def hook [name: string] {
  mkdir devops/git-hooks;
  let exists = $"./devops/git-hooks/($name).nu" | path exists;
  if ($exists == false) {
    [
      $"#!/usr/bin/env nu",
      $"# ($name).nu",
      $"",
      $"print \"($name) - complete\""
    ] | str join "\n" | save -fp $"./devops/git-hooks/($name)";
  }
}

# Expose
def main [] {
}
