# Interactive fish only.
# With Nix, home-manager puts this in config.fish (programs.fish.interactiveShellInit);
# without it, copy this file to ~/.config/fish/conf.d/ as is.

status is-interactive; or return

set -g fish_greeting

## Tell python's activate.fish not to wrap fish_prompt; the prompt shows the venv itself
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

## GPG needs the current terminal
set -gx GPG_TTY (tty)

## Abbreviations expand as you type, so history keeps the real command
abbr -a cls clear

## ^Y accepts the autosuggestion (→ and ^F still work)
bind ctrl-y accept-autosuggestion
## Esc Esc toggles sudo in front of the line, or the previous command (Alt-S does too).
## Pressed quickly, the two escapes arrive as alt-escape, so bind both.
bind escape,escape 'fish_commandline_prepend sudo'
bind alt-escape 'fish_commandline_prepend sudo'

## Don't save these to history
function fish_should_add_to_history
	not string match -qr '^\s*(ls|cd|pwd|exit|cd \.\.)\s*$' -- $argv[1]
end

## Ghostty injects its integration through XDG_DATA_DIRS, which nix-darwin
## overwrites, so load it ourselves (mitchellh's config does the same)
if set -q GHOSTTY_RESOURCES_DIR; and not functions -q __ghostty_setup; and not functions -q __ghostty_mark_prompt_start
	set -l ghostty_fish "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
	test -r $ghostty_fish; and source $ghostty_fish
end
