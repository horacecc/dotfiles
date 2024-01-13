#!/usr/bin/env zsh


#--------------------------------------------------------------#
##        Base                                                ##
#--------------------------------------------------------------#

HOSTNAME="$HOST"
HISTFILE="$XDG_DATA_HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=100000
HISTORY_IGNORE="(ls|cd|pwd|zsh|exit|cd ..)"

#--------------------------------------------------------------#
##        Plugin manager by ZINIT                             ##
##        https://github.com/zdharma-continuum/zinit          ##
#--------------------------------------------------------------#

local _ZINIT="$XDG_DATA_HOME/zinit"

if [[ ! -f "$_ZINIT/zinit.zsh" ]]; then
	git clone https://github.com/zdharma-continuum/zinit.git "$_ZINIT"
fi

source "$_ZINIT/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## Load the oh-my-zsh's library and plugins
## By https://github.com/ohmyzsh/ohmyzsh/
## https://github.com/ohmyzsh/ohmyzsh/tree/master/lib/
## https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/
zinit snippet OMZL::functions.zsh
zinit snippet OMZL::history.zsh

zinit wait lucid for \
	OMZL::directories.zsh \
	OMZL::completion.zsh \
	OMZL::theme-and-appearance.zsh \
	OMZP::colored-man-pages \
	OMZP::sudo

zinit wait lucid for \
	atload"source $XDG_CONFIG_HOME/plugin/key-bindings_atload.zsh" \
	OMZL::key-bindings.zsh

zinit wait lucid \
	if"(( ${ZSH_VERSION%.*} >= 4.4))" \
	atload"source $XDG_CONFIG_HOME/plugin/zsh-autosuggestions_atload.zsh" \
	light-mode for @zsh-users/zsh-autosuggestions

zinit wait lucid \
	if"(( ${ZSH_VERSION%.*} >= 4.3))" \
	light-mode for @zsh-users/zsh-history-substring-search

zinit wait lucid as"completion" \
	atload"zicompinit; zicdreplay" \
	light-mode for @zsh-users/zsh-completions

zinit wait lucid \
	if"(( ${ZSH_VERSION%.*} >= 4.4))" \
	atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
	light-mode for @zdharma-continuum/fast-syntax-highlighting

zinit wait lucid light-mode for \
	atload'_zsh_nvm_lazy_load' \
		@lukechilds/zsh-nvm \
	@MichaelAquilina/zsh-you-should-use

## Set theme
zinit wait lucid \
	atinit"source $XDG_CONFIG_HOME/plugin/zsh-prompt.zsh" \
	light-mode for @spaceship-prompt/spaceship-prompt

#--------------------------------------------------------------#
##        Extra                                               ##
#--------------------------------------------------------------#

## Load bin
fpath=(
	$XDG_CONFIG_HOME/bin
	$fpath
)

autoload -Uz $XDG_CONFIG_HOME/bin/**/*(N:t)

## Load Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

## Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
for file in ~/.{path,aliases,exports,extra}; do
	[ -f "$file" ] && source "$file"
done
unset file
