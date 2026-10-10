# git 的設定
{
  home-manager.sharedModules = [
    {
      # Copied into the Nix store; changes need a switch
      home.file.".gitconfig".source = ./gitconfig;
      xdg.configFile."git/ignore".source = ./ignore;

      # Merges don't open an editor for the commit message. home-manager writes
      # this to hm-session-vars, which config.fish sources
      home.sessionVariables.GIT_MERGE_AUTOEDIT = "no";
    }
  ];
}
