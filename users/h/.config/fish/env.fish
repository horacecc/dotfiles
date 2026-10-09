# Environment for every fish, interactive or not.
# With Nix, home-manager puts this in config.fish (programs.fish.shellInit);
# without it, copy this file to ~/.config/fish/conf.d/ as is.

## Homebrew: what `brew shellenv fish` prints, written out so startup doesn't run brew.
## Compare with `brew shellenv fish` after big Homebrew updates.
if test -d /opt/homebrew
	set -gx HOMEBREW_PREFIX /opt/homebrew
	set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
	set -gx HOMEBREW_REPOSITORY /opt/homebrew
	fish_add_path --global --move --path /opt/homebrew/bin /opt/homebrew/sbin
	## A leading ":" keeps the system man pages after Homebrew's
	if test -n "$MANPATH"
		set -gx MANPATH (string replace --regex '^:*(.*?):*$' ':$1' -- "$MANPATH")
	end
	## Unlike brew's version, don't add it again in nested shells
	if not contains /opt/homebrew/share/info $INFOPATH
		set -q INFOPATH; or set INFOPATH ''
		set -gx INFOPATH /opt/homebrew/share/info $INFOPATH
	end
end

## LANG sets the default for every locale category; leave LC_ALL for one-off overrides
set -gx LANG en_US.UTF-8
set -gx EDITOR vim
set -gx MANPAGER 'less -X' # Don't clear the screen after quitting a manual page.
set -gx GIT_MERGE_AUTOEDIT no

## Colored man pages
set -gx LESS_TERMCAP_md (printf '\e[1;31m')
set -gx LESS_TERMCAP_me (printf '\e[0m')
set -gx LESS_TERMCAP_us (printf '\e[1;32m')
set -gx LESS_TERMCAP_ue (printf '\e[0m')
set -gx LESS_TERMCAP_so (printf '\e[01;33m')
set -gx LESS_TERMCAP_se (printf '\e[0m')

## Private settings live in conf.d/extra.fish, which fish loads by itself
## (see templates/extra.fish; never link or commit the real one)
