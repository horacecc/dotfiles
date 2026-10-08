# h 的家目錄設定
{ config, ... }:
{
  home.stateVersion = "26.05";

  # Copied into the Nix store; changes need a switch
  home.file.".gitconfig".source = ../../.gitconfig;
  home.file.".hushlogin".source = ../../.hushlogin;
  xdg.configFile."git/ignore".source = ../../.config/git/ignore;

  # Points straight at the repo; changes apply without a switch
  xdg.configFile."ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles/.config/ghostty/config";
}
