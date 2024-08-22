#!/usr/bin/env nu
# devops.nu

# std
use std log;

# module
use "./devops-bin/execute.nu" [can_execute];
use "./devops-bin/file.nu" [add, setup_filesystem];
use "./devops-bin/handle.nu" [fexit];

### --- Setup State --- ###
def "main setup" [] {
  can_execute "git" true;
  setup_filesystem;
  
  # Configure Base
  main add-stage 10 "validate";
  main add-stage 20 "build";
  main add-stage 30 "test";
  main add-stage 99 "automation";

  # Add Default Hooks
  main add-hook "pre-commit";
  main add-hook "commit-msg";

  # Configure hooksPath
  git config core.hooksPath "./git-hooks";
}

### --- Execute a stage --- ###
def "main run-stage" [id: int, description: string = '-'] {
  log info $"run-stage|start = './devops/stage-($id).nu';";
  nu $"./devops-conf/stage-($id).nu";
  let exit_code: int = $env.LAST_EXIT_CODE;
  handle_exit $exit_code $description;
}

### --- Create a stage --- ###
def "main add-stage" [id: int, description: string] {
  setup_filesystem;
  
  log info $"add-stage|($id) ($description)";
  (add
    $"devops-conf"
    $"stage-($id).nu"
    $'#!/usr/bin/env nu
      # stage-($id).nu [($description)]

      use std log

      def main [] {
        log info "stage-($id).nu [($description)]";

        # Default Stage Error
        log warning "default stage has not yet been configured"
        error make --unspanned {
          msg: "Failed to execute stage [($id)] '($description)'."
          help: "Please review the above output to resolve this issue." 
        };
      }' 6)
}

### --- Create a git-hook --- ###
def "main add-hook" [hook: string] {
  setup_filesystem;
  
  log info $"hook[create]|hook add ($hook)";
  (add
    $"git-hooks"
    $"($hook)"
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
      }' 4)
}

### --- Upgrade Script from GitHub --- ###
def "main upgrade" [] {
  # update_state;
  
  # if ($env.PWD | str ends-with 'Base') {
  #   log warning $"task[setup]|Local guard triggered. This is the origin of devops.nu and upgrade should not be called here.";
  # } else {
  #   http get "https://raw.githubusercontent.com/xCykrix/Base/main/devops.nu" | save -fp "devops.nu";
  # }
}

### --- Sync Settings to GitHub Repository --- ###
def "main update-github" [] {
  setup_filesystem;

  let search = (git remote get-url origin | into string | parse --regex '(?:https://|git@)github.com[/:]{1}([A-Za-z0-9]{1,})/([A-Za-z0-9]{1,})(?:.git)?')
  if (($search | length) == 0) {
    return (print $"Invalid 'git remote get-url origin' response. Found '($search)'");
  }

  
}

### --- Expose Entrypoints  --- ###
def main [] {
}
