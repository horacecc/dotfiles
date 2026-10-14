#!/bin/sh
set -eu

# The flake only has aarch64-darwin configurations
if [ "$(uname -s)-$(uname -m)" != Darwin-arm64 ]; then
	echo "bootstrap.sh is for Apple silicon Macs only" >&2
	exit 1
fi

# Checked with make installers-check; update each version together with its hash
NIX_VERSION=2.34.6
NIX_INSTALL_SHA256=bf6d12da4aeaae38ab509dc736df648597bcdee051046ea76d3d53d5b18fa54a
BREW_VERSION=7.0.9
BREW_SHA256=e021295947a4a9b7ca1a8eff310c9ea1db14d923c5acf7d79e325b60a81f1a15

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

download() {
	curl --proto '=https' --tlsv1.2 -fsSL -o "$tmp/$2" "$1"
	echo "$3  $tmp/$2" | shasum -a 256 -c
}

# A new shell is needed before nix is on PATH, so check the install location too
if command -v nix >/dev/null 2>&1 || [ -e /nix/var/nix/profiles/default/bin/nix ]; then
	echo "Nix is already installed"
else
	download "https://releases.nixos.org/nix/nix-$NIX_VERSION/install" install "$NIX_INSTALL_SHA256"
	# Flakes don't use channels, and adding one would download nixpkgs
	sh "$tmp/install" --daemon --yes --no-channel-add
fi

if [ -x /opt/homebrew/bin/brew ]; then
	echo "Homebrew is already installed"
else
	download "https://github.com/Homebrew/brew/releases/download/$BREW_VERSION/Homebrew.pkg" \
		Homebrew.pkg "$BREW_SHA256"
	sudo installer -pkg "$tmp/Homebrew.pkg" -target /
fi
