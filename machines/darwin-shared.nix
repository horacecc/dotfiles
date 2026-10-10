# 每台 Mac 共用的系統設定
{ pkgs, currentSystemUser, ... }:
{
  nix.enable = false;
  system.stateVersion = 6;
  home-manager.users.${currentSystemUser}.home.stateVersion = "26.05";

  system.primaryUser = currentSystemUser;
  users.users.${currentSystemUser}.home = "/Users/${currentSystemUser}";

  environment.systemPackages = [
    pkgs.tree
  ];

  # Casks are added by the modules that need them
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };
  };
}
