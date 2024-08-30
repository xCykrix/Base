# xCykrix Base - devops

This is a collection of devops utilities designed to streamline the lifecycle of
development.

This repository is not intended for widespread public use, but please feel free
to do so if you prefer this style of devops.

## Getting Started

Requires nushell. Period. https://www.nushell.sh

1. Install nushell and enter the terminal.
2. Execute

```nu
$ http get https://raw.githubusercontent.com/xCykrix/Base/main/devops-install.nu | save -fp devops-install.nu | nu devops-install.nu
```

Stages of `devops-conf` can be called as needed by git hooks. Additionally, you
can manually call a stage with the following:

> ```
> nu devops.nu run-stage stage-number
> nu devops.nu run-stage 10 # validate
> nu devops.nu run-stage 20 # build
> ```

Stages can be created with `devops.nu add-stage ## code` where code is a single
word descriptor such as build, test, ci, etc. Hooks can be creaed with
`devops.nu add-hook <valid git hook name>` such as `add-hook pre-push`.
