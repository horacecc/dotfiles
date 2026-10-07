#!/usr/bin/env zsh
# By https://spaceship-prompt.sh/config/intro/

spaceship_rprompt_prefix() {
	echo -n '%{'$'\e[1A''%}'
}

spaceship_rprompt_suffix() {
	echo -n '%{'$'\e[1B''%}'
}

## user@host only over SSH (user also shows for root or after `su`)
SPACESHIP_USER_SHOW='true'
SPACESHIP_USER_PREFIX=''
SPACESHIP_USER_SUFFIX=''
SPACESHIP_USER_COLOR='white'

## Without SSH there is no `@host` after the user, so add the space here
[[ -z "$SSH_CONNECTION" ]] && SPACESHIP_USER_SUFFIX=' '

SPACESHIP_HOST_SHOW='true'
SPACESHIP_HOST_PREFIX='@'
SPACESHIP_HOST_SUFFIX=' '
SPACESHIP_HOST_COLOR='white'
SPACESHIP_HOST_COLOR_SSH='white'

SPACESHIP_DIR_PREFIX=''
SPACESHIP_DIR_TRUNC='0'
SPACESHIP_DIR_TRUNC_REPO='false'

SPACESHIP_GIT_SYMBOL=':'
SPACESHIP_GIT_PREFIX='git'

SPACESHIP_VENV_COLOR='magenta'
SPACESHIP_VENV_PREFIX='('
SPACESHIP_VENV_SUFFIX=') '

SPACESHIP_CHAR_SYMBOL='$ '

SPACESHIP_TIME_COLOR=''
SPACESHIP_TIME_SHOW='true'

SPACESHIP_RPROMPT_ORDER=(rprompt_prefix exit_code time exec_time rprompt_suffix)
SPACESHIP_PROMPT_ORDER=(user host dir git line_sep venv char)
