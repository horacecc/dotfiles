# git 的設定
{
  home-manager.sharedModules = [
    {
      # Copied into the Nix store; changes need a switch
      home.file.".gitconfig".source = ./gitconfig;
      xdg.configFile."git/ignore".source = ./ignore;
    }
  ];
}
