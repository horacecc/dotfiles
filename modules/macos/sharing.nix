{ currentSystemUser, ... }:
let
  # Activation runs as root, but Media Sharing is a preference of the user
  asUser = ''launchctl asuser "$(id -u -- ${currentSystemUser})" sudo --user=${currentSystemUser} --'';
in
{
  # Sharing is turned on by hand when it's needed, so a switch only warns about it
  system.activationScripts.postActivation.text = ''
    sharingLoaded() {
      launchctl print "system/$1" >/dev/null 2>&1
    }

    if sharingLoaded com.openssh.sshd; then
      echo "warning: Remote Login is on" >&2
    fi

    if sharingLoaded com.apple.smbd; then
      echo "warning: File Sharing is on" >&2
    fi

    # Remote Management runs on the Screen Sharing service
    if [[ -e "/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd" ]]; then
      echo "warning: Remote Management is on" >&2
    elif sharingLoaded com.apple.screensharing; then
      echo "warning: Screen Sharing is on" >&2
    fi

    if sharingLoaded com.apple.AEServer; then
      echo "warning: Remote Application Scripting is on" >&2
    fi

    if cupsctl | grep -qx '_share_printers=1'; then
      echo "warning: Printer Sharing is on" >&2
    fi

    nat=$(/usr/libexec/PlistBuddy -c 'Print :NAT:Enabled' \
      /Library/Preferences/SystemConfiguration/com.apple.nat.plist 2>/dev/null || true)
    if [[ $nat == 1 || $nat == true ]]; then
      echo "warning: Internet Sharing is on" >&2
    fi

    # home-sharing-enabled is Unverified: Home Sharing needs an Apple Account
    for key in public-sharing-enabled home-sharing-enabled; do
      if [[ $(${asUser} defaults read com.apple.amp.mediasharingd "$key" 2>/dev/null || true) == 1 ]]; then
        echo "warning: Media Sharing is on" >&2
        break
      fi
    done

    # Unverified: content caching can't be turned on in a VM
    if AssetCacheManagerUtil isActivated >/dev/null 2>&1; then
      echo "warning: Content Caching is on" >&2
    fi
  '';
}
