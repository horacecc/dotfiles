# Two-line prompt in the spirit of spaceship, and below each command's output
# when it finished, how long it took (in red from 1m) and, if it failed, its
# exit status in red:
#
#   [user@host] ~/dir git:main !?
#   (venv) $ the command
#   its output
#   ↳ 12:35:10 1m 0s 345ms 1
#
# Nothing is padded to the right edge, so old prompts never wrap when the
# window gets narrower. Uses only what ships with fish (fish_git_prompt,
# $CMD_DURATION, the fish_postexec event).

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
	## First, before any other command overwrites it
	set -l last_status $status

	set -l normal (set_color normal)

	## Line 1: user@host only over SSH, then the full directory and git status
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

	## Line 2: venv, then $ in green, or red after a failed command
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

	## An empty line first, to separate commands
	printf '%s\n' '' $line1
	printf '%s' $line2
end

## Right after a command, below its output (not after an empty Enter or clear)
function __fish_prompt_finished --on-event fish_postexec
	## First, before any other command overwrites it
	set -l last_status $status
	string match -qr '^\s*clear\s*$' -- $argv[1]; and return

	## How long it took: from its largest unit down to ms, like 5ms or
	## 1m 0s 345ms; red from 1m
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

	## If the output didn't end with a newline, start a new line the way fish
	## does: ⏎ and enough spaces to wrap only then, back to column 0, clear it
	printf '%s\r\e[K' (set_color --dim)'⏎'(set_color normal)(string repeat -n (math $COLUMNS - 1) ' ')

	## And the exit status, in red, if it failed
	set -l failed ''
	if test $last_status -ne 0
		set failed " "(set_color --bold red)$last_status(set_color normal)
	end

	printf '%s\n' (set_color --dim)'↳ '(set_color normal)(set_color --bold)(date +%T)(set_color normal)" "(set_color --bold $color)"$took"(set_color normal)$failed
end
