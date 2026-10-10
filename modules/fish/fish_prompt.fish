# Nothing is padded to the right edge, so old prompts never wrap when the
# window gets narrower

set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showupstream auto
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_dirtystate '!'
set -g __fish_git_prompt_char_stagedstate '+'
set -g __fish_git_prompt_char_untrackedfiles '?'
set -g __fish_git_prompt_char_stashstate '$'
set -g __fish_git_prompt_char_upstream_ahead '⇡'
set -g __fish_git_prompt_char_upstream_behind '⇣'
set -g __fish_git_prompt_char_upstream_diverged '⇕'
set -g __fish_git_prompt_char_upstream_equal ''
set -g __fish_git_prompt_color_branch --bold magenta
set -g __fish_git_prompt_color_dirtystate --bold red
set -g __fish_git_prompt_color_stagedstate --bold red
set -g __fish_git_prompt_color_untrackedfiles --bold red
set -g __fish_git_prompt_color_stashstate --bold red
set -g __fish_git_prompt_color_upstream --bold red

function fish_prompt
	## Before anything overwrites it
	set -l last_status $status

	set -l normal (set_color normal)

	set -l left
	if set -q SSH_CONNECTION
		set -a left (set_color --bold white)"$USER@"(prompt_hostname)"$normal "
	end
	set -l dir $PWD
	if string match -q -- "$HOME" $PWD; or string match -q -- "$HOME/*" $PWD
		set dir "~"(string sub -s (math (string length -- $HOME) + 1) -- $PWD)
	end
	set -a left (set_color --bold cyan)$dir$normal
	set -a left (fish_git_prompt ' git:%s')

	set -l line1 (string join '' $left)

	set -l line2
	if set -q VIRTUAL_ENV
		set -a line2 (set_color --bold magenta)"("(path basename $VIRTUAL_ENV)") "$normal
	end
	if test $last_status -eq 0
		set -a line2 (set_color --bold green)'$ '$normal
	else
		set -a line2 (set_color --bold red)'$ '$normal
	end
	set line2 (string join '' $line2)

	printf '%s\n' '' $line1
	printf '%s' $line2
end

function __fish_prompt_finished --on-event fish_postexec
	## Before anything overwrites it
	set -l last_status $status
	string match -qr '^\s*clear\s*$' -- $argv[1]; and return

	set -l ms $CMD_DURATION
	set -l h (math "floor($ms / 3600000)")
	set -l m (math "floor($ms / 60000) % 60")
	set -l s (math "floor($ms / 1000) % 60")
	set -l took
	test $ms -ge 3600000; and set -a took {$h}h
	test $ms -ge 60000; and set -a took {$m}m
	test $ms -ge 1000; and set -a took {$s}s
	set -a took (math "$ms % 1000")ms
	set -l color yellow
	test $ms -ge 60000; and set color red

	## Like fish: if the output didn't end with a newline, ⏎ and spaces wrap to a new line
	printf '%s\r\e[K' (set_color --dim)'⏎'(set_color normal)(string repeat -n (math $COLUMNS - 1) ' ')

	set -l failed ''
	if test $last_status -ne 0
		set failed " "(set_color --bold red)$last_status(set_color normal)
	end

	printf '%s\n' (set_color --dim)'↳ '(set_color normal)(set_color --bold)(date +%T)(set_color normal)" "(set_color --bold $color)"$took"(set_color normal)$failed
end
