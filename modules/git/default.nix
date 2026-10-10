# git 的設定
{ pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      # Copied into the Nix store; changes need a switch
      home.file.".gitconfig".source = ./gitconfig;
      xdg.configFile."git/ignore".source = ./ignore;

      # Merges don't open an editor for the commit message. home-manager writes
      # this to hm-session-vars, which config.fish sources
      home.sessionVariables.GIT_MERGE_AUTOEDIT = "no";

      # gitignore fetches .gitignore templates. writeShellApplication puts it on
      # PATH and runs shellcheck on it when building
      home.packages = [
        (pkgs.writeShellApplication {
          name = "gitignore";
          runtimeInputs = [ pkgs.curl ];
          text = builtins.readFile ./gitignore;
        })
      ];
    }
  ];
}
