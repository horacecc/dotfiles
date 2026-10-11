{
  # Values matching the current macOS defaults are pinned so an update can't change them
  imports = [
    ./activity-monitor.nix
    ./appearance.nix
    ./devices.nix
    ./dock.nix
    ./documents.nix
    ./finder.nix
    ./firewall.nix
    ./keyboard.nix
    ./lock-screen.nix
    ./menu-bar.nix
    ./screenshots.nix
    ./shortcuts.nix
    ./software-update.nix
    ./text-input.nix
    ./trackpad.nix
    ./widgets.nix
    ./windows.nix
  ];

  system.startup.chime = false;
}
