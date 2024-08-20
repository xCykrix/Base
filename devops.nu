#!/usr/bin/env nu
# devops.nu

# State Control
mut set = false;

# Setup
def "main setup" [] {
  # Configure Base
  blank "lint"
  blank "build"
  blank "ci"

  # Prepare Git Dev State
  hook "pre-commit"
  git config core.hooksPath "./devops/git-hooks"
}

# Upgrade
def "main upgrade" [] {
  http get "" | save -fp "devops.upgrade.nu";
}

def "main lint" [] {
  nu "./devops/lint.nu" | complete 
}

def "main build" [] {
  nu "./devops/build.nu" | complete
}

def "main ci" [] {
  nu "./devops/ci.nu" | complete
}

# Quick Wrapper - All Functs
def "main all" [] {
  main lint;
  main build;
  main ci;
}

# Expose
def main [] {
}

# Utilities
def blank [name: string] {
  mkdir devops
  let exists = $"./devops/($name).nu" | path exists
  if ($exists == false) {
    [
      $"#!/usr/bin/env nu",
      $"# ($name).nu",
      "",
      $"print ($name).nu"
    ] | str join "\n" | save -fp $"./devops/($name).nu"
  }
}

def hook [name: string] {
  mkdir devops/git-hooks
  let exists = $"./devops/git-hooks/($name).nu" | path exists
  if ($exists == false) {
    [
      $"#!/usr/bin/env nu",
      $"# ($name).nu",
      $"",
      $"print ($name)"
    ] | str join "\n" | save -fp $"./devops/git-hooks/($name)"
  }
}
