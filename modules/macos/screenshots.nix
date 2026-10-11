{ currentSystemUser, ... }:
{
  system.defaults.screencapture = {
    location = "/Users/${currentSystemUser}/Downloads";
    type = "png";
    disable-shadow = true;
  };
}
