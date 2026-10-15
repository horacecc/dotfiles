# defaults read shows private data, so keep it out of the shared /tmp
DIFFMACOS = $(TMPDIR)/diffmacos

diffmacos:
	defaults read > $(DIFFMACOS)-after
	@if [ ! -f $(DIFFMACOS)-before ]; then \
		cp $(DIFFMACOS)-after $(DIFFMACOS)-before; \
		echo >&2 "run again"; \
		false; \
	fi
	diff -u --color $(DIFFMACOS)-before $(DIFFMACOS)-after || exit 0
	mv $(DIFFMACOS)-after $(DIFFMACOS)-before

installers-check:
	sh scripts/check-installers.sh

installers-latest:
	sh scripts/check-installers.sh --latest

nix-switch:
	sudo darwin-rebuild switch --flake .

.PHONY: diffmacos installers-check installers-latest nix-switch
