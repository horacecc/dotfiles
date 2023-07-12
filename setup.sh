#!/usr/bin/env bash
set -e

function check_os() {
	if [[ "$(uname)" != "Darwin" ]]; then
		echo "Warning: Only supported on macOS"
		exit 1
	fi

	echo "check_OS ... done"
}

function check_zsh() {
	if [[ ! -x "$(command -v zsh)" ]]; then
		echo "Warning: Please install Zsh (https://www.zsh.org/)"
		exit 1
	fi
	
	echo "check_zsh ... done"
}

function check_homebrew() {
	type -p brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

	echo "check_homebrew ... done"
}

function sync() {
	rsync --exclude ".git/" \
		--exclude ".config/" \
		--exclude ".extra" \
		--exclude ".gitconfig.user" \
		--exclude "LICENSE" \
		--exclude "Makefile" \
		--exclude "README.md" \
		--exclude "setup.sh"\
		-avh --no-perms "$(dirname $(dirname "${BASH_SOURCE}"))/." ~

	rsync -avh --no-perms "$(dirname $(dirname "${BASH_SOURCE}"))/.config/." \
		"${XDG_CONFIG_HOME:-$HOME/.config}"
	
	if [[ ! -e "${HOME}/.extra" ]]; then
		cp $(dirname $(dirname "${BASH_SOURCE}"))/.extra ~/.extra
	fi

	if [[ ! -e "${HOME}/.gitconfig.user" ]]; then
		cp $(dirname $(dirname "${BASH_SOURCE}"))/.gitconfig.user ~/.gitconfig.user
	fi

	echo "sync ... done"
}

function tips_zsh() {
	if [[ "$(which zsh)" != "${SHELL}" ]]; then
		echo "==> You can setup Zsh for your default shell."
		echo "    chsh -s $(which zsh) $(whoami)"
	fi
}

function tips_homebrew() {
	echo "==> You can use homebrew:"
	echo "    brew bundle --global --no-upgrade"
}

function start() {
	check_os
	check_zsh
	check_homebrew

	sync

	printf "\nsetup ... done\n"

	tips_zsh
	tips_homebrew
}

start
