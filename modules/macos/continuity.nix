{ currentSystemUser, ... }:
{
  # No other Apple device to share with: the phone is a Pixel
  system.defaults.CustomUserPreferences."com.apple.sharingd".DiscoverableMode = "Off";

  # system.defaults can't write ByHost preferences, which these are
  system.activationScripts.postActivation.text = ''
    launchctl asuser "$(id -u -- ${currentSystemUser})" sudo --user=${currentSystemUser} -- \
      defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool false
    launchctl asuser "$(id -u -- ${currentSystemUser})" sudo --user=${currentSystemUser} -- \
      defaults -currentHost write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool false
    launchctl asuser "$(id -u -- ${currentSystemUser})" sudo --user=${currentSystemUser} -- \
      defaults -currentHost write com.apple.controlcenter AirplayReceiverEnabled -bool false
  '';
}
