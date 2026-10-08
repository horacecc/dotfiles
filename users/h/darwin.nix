# h 在每台 Mac 上都要的系統設定
{ currentSystemUser, ... }:
{
  system.primaryUser = currentSystemUser;
  users.users.${currentSystemUser}.home = "/Users/${currentSystemUser}";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };
    casks = [
      "1password-cli"
      "ghostty"
    ];
  };
}
