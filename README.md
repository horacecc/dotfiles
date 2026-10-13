# Dotfiles

macOS configuration with nix-darwin and home-manager. Each machine is a file in
`machines/`, and each feature is a module in `modules/`.

## Install

```sh
xcode-select --install
```

Then install [Determinate Nix](https://docs.determinate.systems/) and
[Homebrew](https://brew.sh/), and apply the configuration:

```sh
git clone https://github.com/horacecc/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mac
```

Replace `mac` with the machine's file name in `machines/`. If the switch renamed
the computer, switch again: macOS writes the old SMB name back.

## Update

```sh
nix fmt
sudo darwin-rebuild switch --flake .#mac
```

A flake only sees files tracked by Git, so `git add` (or `git add -N`) a new
file before building.

## Homebrew

Homebrew packages are listed in `homebrew.brews` and `homebrew.casks`, in the
machine's file or in the module that configures them. A switch uninstalls every
package that isn't listed, so add packages there instead of with `brew install`.
A switch doesn't upgrade them; run `brew upgrade`.

## Private files

The Nix store is readable by every user, so private settings stay out of Nix and
this repo. Copy each template, never link it, and fill it in:

| Template                    | Copy to                            |
| --------------------------- | ---------------------------------- |
| `templates/.gitconfig.user` | `~/.gitconfig.user`                |
| `templates/op-services`     | `~/.config/op-services`            |
| `templates/extra.fish`      | `~/.config/fish/conf.d/extra.fish` |

## Manual steps

These have no preference that can be written reliably, or are set by hand on
purpose:

- Terminal: import `modules/terminal/Customization.terminal` and make it the default
- Firefox: see [modules/firefox](modules/firefox/README.md)
- Mullvad Browser: see [modules/mullvad_browser](modules/mullvad_browser/README.md)
- UTM (VMs only): turn on Capture Input so shortcuts like ⌘Space reach the VM

## Finding preference keys

Run `make diffmacos`, change the setting in System Settings, and run it again to
see what changed. It only reads the user's preferences, so also compare
`defaults -currentHost read` for ByHost preferences, and find system-wide ones
with:

```sh
touch /tmp/marker
# change the setting
find ~/Library/Preferences /Library/Preferences -newer /tmp/marker -name '*.plist'
```

Settings marked `Unverified` in the modules couldn't be tested in the VM:
`git grep Unverified`.
