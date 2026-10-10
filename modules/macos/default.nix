{
  # Values matching the current macOS defaults are pinned so an update can't change them
  imports = [
    ./appearance.nix
    ./documents.nix
    ./keyboard.nix
    ./shortcuts.nix
    ./text-input.nix
    ./trackpad.nix
    ./widgets.nix
    ./windows.nix
  ];

  system.startup.chime = false;
}
