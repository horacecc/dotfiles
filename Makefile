all: setup

setup:
	bash ./setup.sh
brew:
	brew bundle --global --no-upgrade

cleanbrew:
	brew bundle cleanup --global --force
	brew cleanup

buildbrew:
	brew bundle dump --file=./.Brewfile --force --describe

diffmacos:
	defaults read > /tmp/after
	@if [ ! -f /tmp/before ]; then \
		cp /tmp/after /tmp/before; \
		echo >&2 "run again"; \
		false; \
	fi
	diff -u --color /tmp/before /tmp/after || exit 0
	mv /tmp/after /tmp/before

.PHONY: all setup brew cleanbrew buildbrew diffmacos
