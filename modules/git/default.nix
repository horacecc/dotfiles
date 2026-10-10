{ pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      home.file.".gitconfig".source = ./gitconfig;
      xdg.configFile."git/ignore".source = ./ignore;

      home.sessionVariables.GIT_MERGE_AUTOEDIT = "no";

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
