{ ... }:
{
  imports = [
    ./darwin-shared.nix
    ../modules/fish
    ../modules/ghostty
    ../modules/git
    ../modules/hushlogin
    ../modules/macos
    ../modules/op
    ../modules/terminal
    ../modules/xdg
  ];

  homebrew.brews = [
    "age"
    "exiftool"
    "gnupg"
    "hunk"
    "rclone"
    "sevenzip"
    "tmux"
  ];

  homebrew.casks = [
    "1password"
    "bruno"
    "docker-desktop"
    "ente"
    "firefox"
    "google-chrome"
    "libreoffice"
    "mullvad-browser"
    "mullvad-vpn"
    "obsidian"
    "portfolioperformance"
    "proton-drive"
    "proton-mail"
    "proton-pass"
    "protonvpn"
    "telegram"
    "utm"
    "yubico-authenticator"
  ];
}
