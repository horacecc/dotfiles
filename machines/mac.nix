{ ... }:
{
  imports = [
    ./darwin-shared.nix
    ../modules/cli
    ../modules/fish
    ../modules/ghostty
    ../modules/git
    ../modules/gnupg
    ../modules/hushlogin
    ../modules/macos
    ../modules/op
    ../modules/terminal
    ../modules/tmux
    ../modules/xdg
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
