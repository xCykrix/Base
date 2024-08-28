# Contributing

Leading off, I just want to thank you for taking the time

When contributing to this project, please first reach out via an GitHub Issue or
Discord to keep the project in scope and avoid duplication of work.

Discord: https://discord.gg/RHJQFPgbke

## Contribution - Legal Disclaimer

When contributing to this project, you agree:

- that you have reviewed our Code of Conduct in .github/CODE_OF_CONDUCT.md
- that you have reviewed our Security Policy in .github/SECURITY.md
- that you have the necessary rights to the content submitted
- that the content you contribute may be provided under the project license

Upon submission of this contribution, rights to the content are hereby assigned
to the applicable LICENSE.md associated and this project.

## Getting Started

Contributions to the project are made via GitHub Issues and Pull Requests.

- Report a Vulnerability via GitHub Private Disclosure. Please select the
  "Security" tab to begin this process in GitHub.
- Search for existing Issues and Pull Requests for your contribution idea.
- Issues can take some time to fix as all work done is open source and in
  contributors free time. Please be paitent and call out if issues should be
  prioritized based on impact.

## Issues

Issues are used to report problems or request features. Please reach out via
Discord (link at top) to discuss potential changes to the project.

If you find an issue which matches your problem or request, please feel free to
add a reaction to show your support or comment expanding on the issue or
request. You can also share your steps to reproduce if you encounter a bug
differently.

## Pull Requests

Pull Requests to projects are always welcome and can be a quick way to implement
a feature or fix you would like to see added to the next release. Please reach
out via Discord (link at top) for changes that would require a breaking/major
release.

- PRs should be succient and targetted to a specific feature or issue. You can
  submit multiple pull requests for different scopes and modules. Ideally, they
  should address one issue at a time.
  - You will be asked to refactor pull requests that make multiple wide changes.
- PRs should pass all automated tests and format validation. Feature Requests
  should add additional test kits where applicable.
- PRs should thoroughly documented in usage and examples of APIs where
  applicable.
- Follow the Pull Request Template.

We adhere to Conventional Commits Standard. You can find more at
https://www.conventionalcommits.org/en/v1.0.0/#summary and further extend the
Angular Convention at
https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines

### How to PR

1. Fork the Project to your own GitHub Account.
2. Clone the Project on your device with git.
3. Create a Branch with a succient but detailed name.
4. Commit to that Branch.
5. Apply all Formatting and Test Suites (See: Setting up the Development
   Environmnet Below)
6. Push Changes to the Forked Branch.
7. Create a Pull Request to this Project.

## Setting up the Development Environment

This Project is designed to be compiled and built on Linux with nushell. This
project and devops runtime is built on nushell.

1. Install nushell - [Nushell Landing Page](https://www.nushell.sh)
2. Execute (below) in `nu` shell.

> ```
> $ nu devops.nu setup
> ```

That is it! You are now set up for the local development. Stages of
`devops-conf` will be called as needed by git hooks. Additionally, you can
manually call a stage with the following:

> ```
> nu devops.nu run-stage stage-number
> nu devops.nu run-stage 10 # validate
> nu devops.nu run-stage 20 # build
> ```
