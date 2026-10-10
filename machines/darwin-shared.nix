{ pkgs, currentSystemName, currentSystemUser, ... }:
{
  nix.enable = false;
  system.stateVersion = 6;
  home-manager.users.${currentSystemUser}.home.stateVersion = "26.05";

  system.primaryUser = currentSystemUser;
  users.users.${currentSystemUser}.home = "/Users/${currentSystemUser}";
  networking.computerName = currentSystemName;
  networking.hostName = currentSystemName;

  # Renaming the computer makes macOS rewrite this plist with the old name, so a rename needs a second switch
  system.defaults.smb.NetBIOSName = currentSystemName;

  environment.systemPackages = [
    pkgs.tree
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };
  };
}
