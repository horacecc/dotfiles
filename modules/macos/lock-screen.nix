{ currentSystemUser, ... }:
let
  # Activation runs as root, but the delay belongs to the user's login session
  asUser = ''launchctl asuser "$(id -u -- ${currentSystemUser})" sudo --user=${currentSystemUser} --'';
in
{
  system.defaults.loginwindow.SHOWFULLNAME = true;
  system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.loginwindow".HideUserAvatarAndName =
    true;
  system.defaults.loginwindow.GuestEnabled = false;

  # The delay is not stored in defaults, so system.defaults can't set it
  system.activationScripts.postActivation.text = ''
    # sysadminctl prints the status to stderr; || true keeps set -e from aborting the switch
    if [[ $(${asUser} sysadminctl -screenLock status 2>&1 || true) != *"delay is immediate"* ]]; then
      echo "setting the screen lock delay of ${currentSystemUser} to immediate..." >&2
      # Shortening the delay needs no password, but sysadminctl still requires the flag
      ${asUser} sysadminctl -screenLock immediate -password "" || true
      # Check the result instead of the exit status, in case macOS starts asking for the password
      if [[ $(${asUser} sysadminctl -screenLock status 2>&1 || true) != *"delay is immediate"* ]]; then
        warn "could not set the screen lock delay of ${currentSystemUser} to immediate"
      fi
    fi
  '';
}
