#!/bin/sh
set -eu

# Keeps one issue listing what nix flake update and make installers-latest
# changed in the working tree: opened when there are changes, closed when not

cd "$(dirname "$0")/.."

LABEL=updates
run=$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID

# Reuse the newest issue, open or closed, so updates don't pile up new ones
issue=$(
	gh issue list --label "$LABEL" --state all --limit 1 \
		--json number --jq '.[0].number // empty'
)
state=
if [ -n "$issue" ]; then
	state=$(gh issue view "$issue" --json state --jq .state)
fi

if git diff --quiet; then
	if [ "$state" = OPEN ]; then
		gh issue close "$issue" --comment "Everything is up to date: $run"
	fi
	exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Prints a table row when the committed and updated values of a pin differ
pinned_row() {
	old=$(git show "HEAD:$2" | sed -n "s/^$3=//p")
	new=$(sed -n "s/^$3=//p" "$2")
	if [ "$old" != "$new" ]; then
		echo "| $1 | $old | [$new]($4/$new) |"
	fi
}

pinned_row "Nix installer" bootstrap.sh NIX_VERSION \
	https://github.com/NixOS/nix/releases/tag >"$tmp/pinned"
pinned_row Homebrew.pkg bootstrap.sh BREW_VERSION \
	https://github.com/Homebrew/brew/releases/tag >>"$tmp/pinned"
pinned_row "arkenfox user.js" modules/firefox/arkenfox.sh ARKENFOX_VERSION \
	https://github.com/arkenfox/user.js/releases/tag >>"$tmp/pinned"

git show HEAD:flake.lock >"$tmp/flake.lock"
jq -r --slurpfile old "$tmp/flake.lock" '
	.nodes | to_entries[] | select(.value.locked.rev != null) |
	.key as $name | .value.locked as $new | $old[0].nodes[$name].locked as $prev |
	select($prev != null and $prev.rev != $new.rev) |
	"| \($name) | `\($prev.rev[:7])` \($prev.lastModified | todate[:10]) " +
	"| `\($new.rev[:7])` \($new.lastModified | todate[:10]) " +
	"| [changes](https://github.com/\($new.owner)/\($new.repo)/compare/\($prev.rev)...\($new.rev)) |"
' flake.lock >"$tmp/inputs"

body=$tmp/body
{
	cat <<'END'
Run `nix flake update` and then `make installers-latest`, review the diff and commit it.
END
	if [ -s "$tmp/pinned" ]; then
		cat - "$tmp/pinned" <<'END'

### Pinned versions

| | Pinned | Latest |
| --- | --- | --- |
END
	fi
	if [ -s "$tmp/inputs" ]; then
		cat - "$tmp/inputs" <<'END'

### Flake inputs

| Input | Locked | Latest | |
| --- | --- | --- | --- |
END
	fi
	cat <<'END'

<details><summary>Diff</summary>

```diff
END
	git diff
	cat <<'END'
```

</details>
END
} >"$body"
cat "$body" >>"$GITHUB_STEP_SUMMARY"

if [ -z "$issue" ]; then
	gh label create "$LABEL" --force --description "Pinned versions with updates"
	gh issue create --title "Updates available" --label "$LABEL" --body-file "$body"
	exit 0
fi

if [ "$state" = CLOSED ]; then
	gh issue edit "$issue" --body-file "$body"
	gh issue reopen "$issue" --comment "New updates: $run"
elif [ "$(gh issue view "$issue" --json body --jq .body)" != "$(cat "$body")" ]; then
	gh issue edit "$issue" --body-file "$body"
	gh issue comment "$issue" --body "New updates: $run"
fi
