#!/usr/bin/env zsh
# By https://github.com/zsh-users/zsh-history-substring-search

## https://github.com/zsh-users/zsh-history-substring-search#usage
## Bind both the normal and the application-mode (terminfo) arrow keys
for keymap in emacs viins; do
	bindkey -M "$keymap" '^[[A' history-substring-search-up
	bindkey -M "$keymap" '^[[B' history-substring-search-down
	[[ -n "${terminfo[kcuu1]}" ]] && bindkey -M "$keymap" "${terminfo[kcuu1]}" history-substring-search-up
	[[ -n "${terminfo[kcud1]}" ]] && bindkey -M "$keymap" "${terminfo[kcud1]}" history-substring-search-down
done
unset keymap
