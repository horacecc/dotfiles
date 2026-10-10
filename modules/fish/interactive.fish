status is-interactive; or return

set -g fish_greeting

## fish_prompt shows the venv itself
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx GPG_TTY (tty)
