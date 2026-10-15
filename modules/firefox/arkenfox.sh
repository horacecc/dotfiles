#!/bin/sh
set -eu

# Update the version together with its hash: https://github.com/arkenfox/user.js/tags
ARKENFOX_VERSION=144.0
ARKENFOX_SHA256=e4ab33c6914899175cf7035e0e57a2d7f08ac887d8f957f1199e7e49bbe7e33e

if [ $# -ne 1 ] || [ ! -f "$1/prefs.js" ]; then
	echo "usage: arkenfox.sh <Firefox profile directory>" >&2
	exit 1
fi
profile=$1
overrides=$(dirname "$0")/user-overrides.js

# Firefox writes prefs.js when it quits, which would undo the cleanup below
if pgrep -xq firefox; then
	echo "Quit Firefox first" >&2
	exit 1
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

curl --proto '=https' --tlsv1.2 -fsSL -o "$tmp/user.js" \
	"https://raw.githubusercontent.com/arkenfox/user.js/$ARKENFOX_VERSION/user.js"
echo "$ARKENFOX_SHA256  $tmp/user.js" | shasum -a 256 -c

cat "$tmp/user.js" "$overrides" >"$tmp/new.js"

old=$profile/user.js
[ -f "$old" ] || old=/dev/null

# prefs.js keeps the values user.js sets, so a pref dropped from user.js would keep
# its old value; removing every pref either user.js sets resets those to the default
cat "$old" "$tmp/new.js" |
	sed -n 's/^user_pref("\([^"]*\)".*/user_pref("\1",/p' >"$tmp/patterns"
grep -vF -f "$tmp/patterns" "$profile/prefs.js" >"$tmp/prefs.js" || [ $? -eq 1 ]

[ "$old" = /dev/null ] || cp "$old" "$profile/user.js.bak"
cp "$profile/prefs.js" "$profile/prefs.js.bak"
cp "$tmp/new.js" "$profile/user.js"
cp "$tmp/prefs.js" "$profile/prefs.js"
echo "Wrote arkenfox $ARKENFOX_VERSION and user-overrides.js; start Firefox to apply them"
