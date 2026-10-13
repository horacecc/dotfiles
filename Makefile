diffmacos:
	defaults read > /tmp/after
	@if [ ! -f /tmp/before ]; then \
		cp /tmp/after /tmp/before; \
		echo >&2 "run again"; \
		false; \
	fi
	diff -u --color /tmp/before /tmp/after || exit 0
	mv /tmp/after /tmp/before

.PHONY: diffmacos
