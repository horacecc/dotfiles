{ currentSystemUser, ... }:
{
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
