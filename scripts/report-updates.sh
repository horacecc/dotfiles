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

body=$(mktemp)
{
	cat <<'END'
Run `nix flake update` and then `make installers-latest`, review the diff and commit it.

```
END
	git diff --stat
	cat <<'END'
```

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
