{ config, ... }:
{
  home.stateVersion = "26.05";

  # Copied into the Nix store; changes need a switch
  home.file.".gitconfig".source = ./.gitconfig;

  # Points straight at the repo; changes apply without a switch
  xdg.configFile."ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotfiles/.config/ghostty/config";
}
