{
  # Values matching the current macOS defaults are pinned so an update can't change them
  imports = [
    ./activity-monitor.nix
    ./appearance.nix
    ./continuity.nix
    ./date-time.nix
    ./devices.nix
    ./dock.nix
    ./documents.nix
    ./filevault.nix
    ./finder.nix
    ./firewall.nix
    ./keyboard.nix
    ./lock-screen.nix
    ./menu-bar.nix
    ./power.nix
    ./privacy.nix
    ./screenshots.nix
    ./sharing.nix
    ./shortcuts.nix
    ./software-update.nix
    ./text-input.nix
    ./trackpad.nix
    ./widgets.nix
    ./windows.nix
  ];

  system.startup.chime = false;
}
