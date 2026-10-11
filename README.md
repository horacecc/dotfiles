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
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#utm
sudo darwin-rebuild switch --flake .#utm
```

The second switch is needed because renaming the computer makes macOS write the
old SMB name back.

Then log out and back in: macOS reads most preferences at login, and nix-darwin
restarts no apps. Files that home-manager would have overwritten are kept with a
`.before-home-manager` suffix; review and delete them.

## Update

```sh
nix fmt
sudo darwin-rebuild switch --flake .#utm
```

A flake only sees files tracked by Git, so `git add` (or `git add -N`) a new
file before building.

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
