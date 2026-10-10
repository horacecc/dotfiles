# Interactive fish only.
# With Nix, home-manager puts this in config.fish (programs.fish.interactiveShellInit);
# without it, copy this file to ~/.config/fish/conf.d/ as is.

status is-interactive; or return

set -g fish_greeting

## Tell python's activate.fish not to wrap fish_prompt; the prompt shows the venv itself
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

## GPG needs the current terminal
set -gx GPG_TTY (tty)
