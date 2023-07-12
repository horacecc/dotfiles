#!/usr/bin/env zsh
# By https://spaceship-prompt.sh/config/intro/

spaceship_rprompt_prefix() {
	echo -n '%{'$'\e[1A''%}'
}

spaceship_rprompt_suffix() {
	echo -n '%{'$'\e[1B''%}'
}

SPACESHIP_CHAR_SYMBOL='$ '
SPACESHIP_DIR_TRUNC='0'
SPACESHIP_DIR_TRUNC_REPO='false'
SPACESHIP_GIT_SYMBOL=':'
SPACESHIP_GIT_PREFIX='git'
SPACESHIP_HOST_SHOW='always'
SPACESHIP_TIME_COLOR=''
SPACESHIP_TIME_SHOW='true'
SPACESHIP_USER_SHOW='always'
SPACESHIP_VENV_COLOR='magenta'
SPACESHIP_VENV_PREFIX='('
SPACESHIP_VENV_SUFFIX=') '

SPACESHIP_RPROMPT_ORDER=(rprompt_prefix exit_code time exec_time rprompt_suffix)
SPACESHIP_PROMPT_ORDER=(user host dir git line_sep venv char)
