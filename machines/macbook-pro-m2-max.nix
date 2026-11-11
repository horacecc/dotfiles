{ ... }:
{
  imports = [
    ./darwin-shared.nix
    ../modules/cli
    ../modules/colima
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
    "ente"
    "firefox"
    "libreoffice"
    "mullvad-browser"
    "mullvad-vpn"
    "obsidian"
    "portfolioperformance"
    "proton-drive"
    "proton-mail"
    "proton-pass"
    "telegram"
    "utm"
    "yubico-authenticator"
  ];
}
