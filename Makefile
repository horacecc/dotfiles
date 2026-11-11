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

# switch records the configuration as the system before activating it, so run
# only the activation checks first; darwin-rebuild check would activate it too
# once they pass, since the script's env -i drops checkActivation
# (nix-darwin/nix-darwin#1700)
nix-switch:
	darwin-rebuild build --flake .
	sudo env checkActivation=1 ./result/sw/bin/bash ./result/activate
	sudo darwin-rebuild switch --flake .

.PHONY: diffmacos installers-check installers-latest nix-switch
