#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function check_os() {
	if [[ "$(uname)" != "Darwin" ]]; then
		echo "Warning: Only supported on macOS"
		exit 1
	fi

	echo "==> Check OS ... done"
}

function check_zsh() {
	if [[ ! -x "$(command -v zsh)" ]]; then
		echo "Warning: Please install Zsh (https://www.zsh.org/)"
		exit 1
	fi
	
	echo "==> Check zsh ... done"
}

function check_homebrew() {
	type -p brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	echo "==> Check Homebrew ... done"
}

function sync() {
	echo "==> Start sync ..."
	rsync --exclude ".git/" \
		--exclude ".config/" \
		--exclude ".extra" \
		--exclude ".gitconfig.user" \
		--exclude "LICENSE" \
		--exclude ".macos" \
		--exclude "Makefile" \
		--exclude "README.md" \
		--exclude "setup.sh"\
		-avh --no-perms "${DOTFILES}/." ~

	rsync -avh --no-perms "${DOTFILES}/.config/." \
		"${XDG_CONFIG_HOME:-$HOME/.config}"
	
	if [[ ! -e "${HOME}/.extra" ]]; then
		cp "${DOTFILES}/.extra" ~/.extra
	fi

	if [[ ! -e "${HOME}/.gitconfig.user" ]]; then
		cp "${DOTFILES}/.gitconfig.user" ~/.gitconfig.user
	fi

	echo "==> Sync ... done"
}

function display_zsh_setup_instructions() {
	if [[ "$(which zsh)" != "${SHELL}" ]]; then
		echo "==> You can setup Zsh for your default shell."
		echo "    chsh -s $(which zsh) $(whoami)"
	fi
}

function display_homebrew_usage_instructions() {
	echo "==> You can use homebrew:"
	echo "    brew bundle --global --no-upgrade"
}

function start() {
	check_os
	check_zsh
	check_homebrew

	sync

	printf "==> Setup ... done\n"

	display_zsh_setup_instructions
	display_homebrew_usage_instructions
}

start
