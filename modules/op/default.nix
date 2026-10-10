{
  lib,
  pkgs,
  isDarwin,
  ...
}:
{
  home-manager.sharedModules = [
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "op";
          text = builtins.readFile ./op;
        })
      ];
    }
  ];
}
// lib.optionalAttrs isDarwin {
  homebrew.casks = [ "1password-cli" ];
}
