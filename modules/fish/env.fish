## `brew shellenv fish`, written out so startup doesn't run brew
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

## home-manager's packages before Homebrew's, so the op wrapper runs before the real op
fish_add_path --global --move --path /etc/profiles/per-user/$USER/bin

set -gx LANG en_US.UTF-8
set -gx EDITOR vim
set -gx MANPAGER 'less -X' # Don't clear the screen after quitting a manual page.

## Colored man pages
set -gx LESS_TERMCAP_md (printf '\e[1;31m')
set -gx LESS_TERMCAP_me (printf '\e[0m')
set -gx LESS_TERMCAP_us (printf '\e[1;32m')
set -gx LESS_TERMCAP_ue (printf '\e[0m')
set -gx LESS_TERMCAP_so (printf '\e[01;33m')
set -gx LESS_TERMCAP_se (printf '\e[0m')
