#!/bin/sh
set -eu

cd "$(dirname "$0")/.."

BOOTSTRAP=bootstrap.sh
BREW_REPO=https://github.com/Homebrew/brew
ARKENFOX=modules/firefox/arkenfox.sh
ARKENFOX_REPO=https://github.com/arkenfox/user.js

fail() {
	echo "error: $*" >&2
	exit 1
}

pinned() {
	sed -n "s/^$1=//p" "${2:-$BOOTSTRAP}"
}

# bootstrap.sh checks the same signer before it installs the package
BREW_TEAM_ID=$(pinned BREW_TEAM_ID)

# Like bootstrap.sh, refuse plain HTTP, also on a redirect
fetch() {
	curl --proto '=https' --tlsv1.2 -fsS "$@"
}

normalize() {
	sed -E \
		-e 's/@[a-z-]+@/STORE/g' \
		-e 's|/nix/store/[0-9a-z]{32}-[A-Za-z0-9._+-]+|STORE|g' \
		"$1"
}

if [ "${1:-}" = --latest ]; then
	# nix-darwin replaces the installed Nix with this one, so the first switch keeps the version
	nix_version=$(nix eval --raw --inputs-from . nixpkgs#nix.version)
	# nixpkgs appends +N when it patches Nix; the release is published without it
	nix_version=${nix_version%%+*}

	brew_version=$(fetch -o /dev/null -w '%{redirect_url}' "$BREW_REPO/releases/latest")
	brew_version=${brew_version##*/}

	# Releases are tagged like 144.0; older tags have a v prefix or a -beta suffix
	arkenfox_version=$(
		git ls-remote --tags --refs "$ARKENFOX_REPO" |
			sed -n 's|.*refs/tags/\([0-9]*\.[0-9]*\)$|\1|p' |
			sort -t . -k 1,1n -k 2,2n |
			tail -n 1
	)
else
	nix_version=$(pinned NIX_VERSION)
	brew_version=$(pinned BREW_VERSION)
	arkenfox_version=$(pinned ARKENFOX_VERSION "$ARKENFOX")
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "== Nix $nix_version"

nix_url=https://releases.nixos.org/nix/nix-$nix_version
fetch -L -o "$tmp/install" "$nix_url/install"
nix_install_sha256=$(shasum -a 256 "$tmp/install" | cut -d' ' -f1)

tarball_hash=$(sed -n '/Darwin.arm64/,/;;/s/.*hash=//p' "$tmp/install")
tarball_path=$(sed -n '/Darwin.arm64/,/;;/s/.*path=//p' "$tmp/install")
tarball=${tarball_path#*/}

fetch -L -o "$tmp/$tarball" "$nix_url/$tarball"
echo "$tarball_hash  $tmp/$tarball" | shasum -a 256 -c

# Nix only substitutes paths signed by a trusted key, so this proves Hydra built the tarball
store_path=$(
	fetch -L "https://cache.nixos.org/${tarball_path%%/*}.narinfo" |
		sed -n 's/^StorePath: //p'
)
nix-store --realise "$store_path" >/dev/null
nix store verify --sigs-needed 1 "$store_path"
echo "$tarball_hash  $store_path/$tarball" | shasum -a 256 -c

tar -xJf "$tmp/$tarball" -C "$tmp"
for pair in \
	install:install-nix-from-tarball.sh \
	install-multi-user:install-multi-user.sh \
	install-darwin-multi-user.sh:install-darwin-multi-user.sh \
	create-darwin-volume.sh:create-darwin-volume.sh; do
	packed=$tmp/${tarball%.tar.xz}/${pair%%:*}
	source=https://raw.githubusercontent.com/NixOS/nix/$nix_version/scripts/${pair#*:}
	fetch -L -o "$tmp/source" "$source"

	# Packaging only replaces @placeholders@ with store paths
	normalize "$tmp/source" >"$tmp/source.norm"
	normalize "$packed" >"$tmp/packed.norm"
	diff "$tmp/source.norm" "$tmp/packed.norm" >/dev/null ||
		fail "${pair%%:*} differs from $source"

	echo "${pair%%:*}: matches the source"
done

echo "== Homebrew $brew_version"

fetch -L -o "$tmp/Homebrew.pkg" "$BREW_REPO/releases/download/$brew_version/Homebrew.pkg"
brew_sha256=$(shasum -a 256 "$tmp/Homebrew.pkg" | cut -d' ' -f1)

pkgutil --check-signature "$tmp/Homebrew.pkg" >"$tmp/signature" ||
	fail "Homebrew.pkg is not signed"
grep -q 'Notarization: trusted by the Apple notary service' "$tmp/signature" ||
	fail "Homebrew.pkg is not notarized"
grep -q "Developer ID Installer: .*($BREW_TEAM_ID)" "$tmp/signature" ||
	fail "Homebrew.pkg is not signed by team $BREW_TEAM_ID"
echo "Homebrew.pkg: notarized and signed by team $BREW_TEAM_ID"

pkgutil --expand-full "$tmp/Homebrew.pkg" "$tmp/brew"
payload=$tmp/brew/Homebrew.pkg/Payload
scripts=$tmp/brew/Homebrew.pkg/Scripts

# For an annotated tag the peeled ^{} line comes last
tag_commit=$(
	git ls-remote "$BREW_REPO" "refs/tags/$brew_version" "refs/tags/$brew_version^{}" |
		tail -n 1 |
		cut -f1
)
[ "$(git -C "$payload" rev-parse HEAD)" = "$tag_commit" ] ||
	fail "Homebrew.pkg isn't the $brew_version tag"
git -C "$payload" fsck --no-dangling --no-progress

# The release workflow filters the test fixtures out of the package
# because they hold unsigned binaries
if git -C "$payload" status --porcelain --untracked-files=no |
	grep -v '^ D Library/Homebrew/test/support/fixtures/'; then
	fail "Homebrew.pkg changes files of the $brew_version tag"
fi

for pair in \
	preinstall:package/scripts/preinstall \
	postinstall:package/scripts/postinstall \
	macos_user.sh:Library/Homebrew/utils/macos_user.sh; do
	git -C "$payload" show "HEAD:${pair#*:}" | diff - "$scripts/${pair%%:*}" >/dev/null ||
		fail "the ${pair%%:*} script differs from ${pair#*:}"
done
echo "Homebrew.pkg: the code and install scripts match the $brew_version tag"

echo "== arkenfox $arkenfox_version"

# arkenfox.sh downloads the raw file, so check it against the tag itself
fetch -L -o "$tmp/user.js" \
	"https://raw.githubusercontent.com/arkenfox/user.js/$arkenfox_version/user.js"
arkenfox_sha256=$(shasum -a 256 "$tmp/user.js" | cut -d' ' -f1)
git -c advice.detachedHead=false clone -q --depth 1 -b "$arkenfox_version" \
	"$ARKENFOX_REPO" "$tmp/arkenfox"
cmp -s "$tmp/user.js" "$tmp/arkenfox/user.js" ||
	fail "the raw user.js differs from the $arkenfox_version tag"
echo "user.js: the raw download matches the $arkenfox_version tag"

if [ "${1:-}" = --latest ]; then
	sed -i '' \
		-e "s/^NIX_VERSION=.*/NIX_VERSION=$nix_version/" \
		-e "s/^NIX_INSTALL_SHA256=.*/NIX_INSTALL_SHA256=$nix_install_sha256/" \
		-e "s/^BREW_VERSION=.*/BREW_VERSION=$brew_version/" \
		-e "s/^BREW_SHA256=.*/BREW_SHA256=$brew_sha256/" \
		"$BOOTSTRAP"
	sed -i '' \
		-e "s/^ARKENFOX_VERSION=.*/ARKENFOX_VERSION=$arkenfox_version/" \
		-e "s/^ARKENFOX_SHA256=.*/ARKENFOX_SHA256=$arkenfox_sha256/" \
		"$ARKENFOX"
	git diff --stat -- "$BOOTSTRAP" "$ARKENFOX"
else
	[ "$nix_install_sha256" = "$(pinned NIX_INSTALL_SHA256)" ] ||
		fail "the Nix install script changed since it was pinned"
	[ "$brew_sha256" = "$(pinned BREW_SHA256)" ] ||
		fail "Homebrew.pkg changed since it was pinned"
	[ "$arkenfox_sha256" = "$(pinned ARKENFOX_SHA256 "$ARKENFOX")" ] ||
		fail "arkenfox's user.js changed since it was pinned"
	echo "== all pinned hashes match"
fi
