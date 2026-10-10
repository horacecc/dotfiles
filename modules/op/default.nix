# 1Password CLI: installed with Homebrew, wrapped by our op
{
  lib,
  pkgs,
  isDarwin,
  ...
}:
{
  home-manager.sharedModules = [
    {
      # op wraps the real op: in the directories listed in ~/.config/op-services
      # it runs with that service account's token from the Keychain.
      # writeShellApplication puts it on PATH and runs shellcheck on it when building
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
  # The real op
  homebrew.casks = [ "1password-cli" ];
}
