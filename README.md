# Dotfiles

macOS configuration with nix-darwin and home-manager. Each machine is a file in
`machines/`, and each feature is a module in `modules/`.

## Install

```sh
xcode-select --install
```

When the Command Line Tools finish installing, download, read and run
`bootstrap.sh`. It installs [Nix](https://nixos.org/) with its official install
script and [Homebrew](https://brew.sh/) from its notarized package, each pinned by
SHA-256:

```sh
curl -fsSLO https://raw.githubusercontent.com/horacecc/dotfiles/main/bootstrap.sh
less bootstrap.sh
sh bootstrap.sh
```

Then, in a new terminal, build the configuration and switch to it with the
nix-darwin version that `flake.lock` pins:

```sh
git clone https://github.com/horacecc/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
nix --extra-experimental-features 'nix-command flakes' build .#darwinConfigurations.mac.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#mac
```

Replace `mac` in both commands with the machine's file name in `machines/`. If
the switch renamed the computer, run `make nix-switch` in a new terminal: macOS
writes the old SMB name back.

Then log out and back in: macOS reads most preferences at login, and nix-darwin
restarts no apps. Files that home-manager would have overwritten are kept with a
`.before-home-manager` suffix; review and delete them.

## Update

```sh
nix fmt
make nix-switch
```

`make nix-switch` builds the configuration named by `scutil --get LocalHostName`.

A flake only sees files tracked by Git, so `git add` (or `git add -N`) a new
file before building.

## Homebrew

Homebrew packages are listed in `homebrew.brews` and `homebrew.casks`, in the
machine's file or in the module that configures them. A switch uninstalls every
package that isn't listed, so add packages there instead of with `brew install`.

A switch doesn't upgrade them, so run `brew upgrade` every week. It skips casks
that update themselves, such as Firefox and Chrome.

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
