{ currentSystemUser, ... }:
{
  # system.defaults can't write ByHost preferences, which these are
  # Spotlight = 8 doesn't hide the icon by itself; it mirrors what System Settings writes
  system.activationScripts.postActivation.text = ''
    launchctl asuser "$(id -u -- ${currentSystemUser})" sudo --user=${currentSystemUser} -- \
      defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
    launchctl asuser "$(id -u -- ${currentSystemUser})" sudo --user=${currentSystemUser} -- \
      defaults -currentHost write com.apple.controlcenter Spotlight -int 8
    launchctl asuser "$(id -u -- ${currentSystemUser})" sudo --user=${currentSystemUser} -- \
      defaults -currentHost write com.apple.controlcenter WiFi -int 2
  '';
}
