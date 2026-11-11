{ currentSystemUser, ... }:
{
  # The system-wide copy of this preference is protected by TCC, so only the
  # user one is written
  system.defaults.CustomUserPreferences."com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;

  # system.defaults can't write ByHost preferences, which this one is
  system.activationScripts.postActivation.text = ''
    launchctl asuser "$(id -u -- ${currentSystemUser})" sudo --user=${currentSystemUser} -- \
      defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
  '';
}
