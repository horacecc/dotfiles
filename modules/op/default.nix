{ lib, pkgs, ... }:
{
  # The only unfree package; a second one needs a shared list, since this is a function
  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "1password-cli";

  home-manager.sharedModules = [
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "op";
          # The real op stays out of PATH, so this wrapper is the only op there
          text = builtins.replaceStrings [ "@op@" ] [ "${pkgs._1password-cli}/bin/op" ] (
            builtins.readFile ./op
          );
        })
      ];
    }
  ];
}
