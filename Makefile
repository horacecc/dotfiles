diffmacos:
	defaults read > /tmp/after
	@if [ ! -f /tmp/before ]; then \
		cp /tmp/after /tmp/before; \
		echo >&2 "run again"; \
		false; \
	fi
	diff -u --color /tmp/before /tmp/after || exit 0
	mv /tmp/after /tmp/before

installers-check:
	sh scripts/check-installers.sh

installers-latest:
	sh scripts/check-installers.sh --latest

nix-switch:
	sudo darwin-rebuild switch --flake .

.PHONY: diffmacos installers-check installers-latest nix-switch
