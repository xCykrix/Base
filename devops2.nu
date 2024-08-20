#!/usr/bin/env nu
# devops.nu

# State Control
mut set = false;

# Setup
def "main setup" [] {
  # Configure Base
  blank "stage-1.lint"
  blank "stage-2.build"
  blank "stage-3.ci"

  # Prepare Git Dev State
  hook "pre-commit"
  git config core.hooksPath "./devops/git-hooks"
}

# Upgrade
def "main upgrade" [] {
  http get "" | save -fp "devops.upgrade.nu";
}

def "main lint" [] {
  nu "./devops/stage-1.lint.nu" | complete 
}

def "main build" [] {
  nu "./devops/stage-2.build.nu" | complete
}

def "main ci" [] {
  nu "./devops/stage-3.ci.nu" | complete
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
