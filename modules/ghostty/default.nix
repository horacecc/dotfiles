# Ghostty：安裝和設定
{ lib, isDarwin, ... }:
{
  home-manager.sharedModules = [
    {
      # Copied into the Nix store; changes need a switch
      xdg.configFile."ghostty/config".source = ./config;
    }
  ];
}
// lib.optionalAttrs isDarwin {
  homebrew.casks = [ "ghostty" ];
}
