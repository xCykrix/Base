#!/usr/bin/env nu
# devops-install.nu

# std
use std log;

### --- Expose Entrypoints  --- ###
def main [] {
  if ($env.PWD | str ends-with 'Base') {
    return (log warning $"Local guard triggered. This is the origin of devops.nu and upgrade should not be called here. [ends-with 'Base']");
  }

  let temp = (mktemp -d)
  git clone https://github.com/xCykrix/Base.git $temp;
  mkdir devops/.state;
  mkdir devops/conf;
  mkdir devops/hook;

  cp -rv $"($temp)/devops/.state" .;
  cp -rv $"($temp)/devops.nu" .;
  cp -rv $"($temp)/devops-install.nu" .;

  cp -rv $"($temp)/.editorconfig" .;
  cp -rv $"($temp)/devops/hook/commit-msg" ./devops/hook/commit-msg;
  rm ./devops-install.nu;
  rm -rf $"($temp)";
  log info "Base devops.nu and devops-bin have been installed and updated. Running setup.";
  nu ./devops.nu setup;
}
