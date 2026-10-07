# Dotfiles

```bash
bash ./setup.sh
./.macos
make brew
```

`setup.sh` copies files into `~` and `~/.config` with rsync, which never deletes.
When a file is removed from this repo, delete its copy by hand.

## Benchmark & Performance

```bash
# Real interactive latency (https://github.com/romkatv/zsh-bench)
~/zsh-bench/zsh-bench

# Per-plugin load time
zinit times
```

`time zsh -i -c exit` exits before zinit turbo plugins load, so it underestimates
startup time.
