#!/usr/bin/env nu
# devops.nu

use std log;

# Setup
def "main setup" [] {
  # Check for Updates
  check_update;

  # .gitignore
  (generate
    ".gitignore"
    $".update-cache
    env.json
    "
    4)

  # Configure GitHub
  (generate
    "env.json"
    $"{
      "gh_actor": "username",
      "gh_access": "personal-access-token-repo-admin"
    }
    "
    4)


  # Configure Base
  main add-stage 10 "validate";
  main add-stage 20 "build";
  main add-stage 30 "test";
  main add-stage 99 "automation";

  # Add Default Hooks
  main add-hook "pre-commit";
  main add-hook "commit-msg";

  # Configure hooksPath
  git config core.hooksPath "./devops/git-hooks";
}

# Run Specified Stage
def "main run-stage" [id: int, task: string = '-'] {
  log info $"task[execute]|start = './devops/stage-($id).nu';";
  nu $"./devops/stage-($id).nu";
  let exit_code: int = $env.LAST_EXIT_CODE;
  handle_exit $exit_code $"($task)";
}

# Add Stage
def "main add-stage" [id: int, task: string] {
  log info $"task[create]|stage add ($id) ($task)";
  (generate
    $"stage-($id).nu"
    $'#!/usr/bin/env nu
    # stage-($id).nu [($task)]

    use std log

    def main [] {
      log info "stage-($id).nu [($task)]";

      # Default Stage Error
      log warning "default stage has not yet been configured"
      error make --unspanned {
        msg: "Failed to execute stage [($id)] '($task)'."
        help: "Please review the above output to resolve this issue." 
      };
    }
    '
    4
  )
}

# Add Hook
def "main add-hook" [hook: string] {
  log info $"hook[create]|hook add ($hook)";
  (generate
    $"git-hooks/($hook)"
    $'#!/usr/bin/env nu
    # git-hook: ($hook)

    use std log;

    def main [0?: string, 1?: string] {
      log info "hook: ($hook)";

      # Default Hook Error
      log warning "default hook has not yet been configured"
      error make --unspanned {
        msg: "Failed to execute hook '($hook)'."
        help: "Please review the above output to resolve this issue." 
      };
    }
    '
    4
  )
}

# Upgrade
def "main upgrade" [] {
  if ($env.PWD | str ends-with 'Base') {
    log warning $"task[setup]|Local guard triggered. This is the origin of devops.nu and upgrade should not be called here.";
  } else {
    http get "https://raw.githubusercontent.com/xCykrix/Base/main/devops.nu" | save -fp "devops.nu";
  }
}

# GitHub Settings

# Functs
def handle_exit [exit_code: int, id: string] {
  if ($exit_code != 0) {
    log error $"task[($id)]|failed to execute task with exit code of ($exit_code)";
    exit $exit_code;
  }
  exit 0;
}

# Generate File from ID, Content, and Space Count
def generate [id: string, content: string, space: int = 6] {
  mkdir devops/git-hooks;
  let exists = $"./devops/($id)" | path exists;
  if ($exists == false) {
    mut result = [];
    for $it in ($content | lines) {
      if (($result | length) == 0) {
        $result = ($result | append $"($it)")
      } else {
        $result = ($result | append $"($it | str substring $space..)")
      }
    }
    $result | str join "\n" | save -fp $"./devops/($id)";
  }
}

# Check for Updates with Caching
def check_update [] {
  mkdir devops;

  # Calculate Hashes
  let current_hash: string = (open "./devops.nu" | hash sha256 | into string);
  mut refresh_hash = "TO_BE_CALCULATED";

  # Hit Cache or Fetch Remote
  if (($"./devops/.update-cache" | path exists) and ((ls $"./devops/.update-cache" | get 0.modified) > ((date now) - 15min))) {
    $refresh_hash = (open "./devops/.update-cache" | into string);
  } else {
    $refresh_hash = (http get "https://raw.githubusercontent.com/xCykrix/Base/main/devops.nu" | hash sha256 | into string);
    $refresh_hash | save -fp $"./devops/.update-cache";
  }

  # Diff
  if ($current_hash != $refresh_hash) {
    log warning $"task[setup]|An update to base devops tooling is available. please run 'nu ./devops.nu upgrade' to install.";
  }
}

# Expose
def main [] {
}
