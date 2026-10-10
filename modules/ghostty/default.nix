# Ghostty：安裝和設定
{ lib, isDarwin, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        # Points straight at the repo; changes apply without a switch
        xdg.configFile."ghostty/config".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles/modules/ghostty/config";
      }
    )
  ];
}
// lib.optionalAttrs isDarwin {
  homebrew.casks = [ "ghostty" ];
}
