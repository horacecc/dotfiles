{ lib, ... }:
{
  imports = [
    ./darwin-shared.nix
    ../modules/fish
    ../modules/ghostty
    ../modules/git
    ../modules/hushlogin
    ../modules/macos
    ../modules/op
    ../modules/xdg
  ];

  # The host Mac handles Control-Space before UTM can capture it
  system.defaults.CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys."60" =
    lib.mkForce { enabled = true; value = { type = "standard"; parameters = [ 32 49 1310720 ]; }; };
}
