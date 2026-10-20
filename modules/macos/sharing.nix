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
      warn "Remote Login is on"
    fi

    if sharingLoaded com.apple.smbd; then
      warn "File Sharing is on"
    fi

    # Remote Management runs on the Screen Sharing service
    if [[ -e "/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd" ]]; then
      warn "Remote Management is on"
    elif sharingLoaded com.apple.screensharing; then
      warn "Screen Sharing is on"
    fi

    if sharingLoaded com.apple.AEServer; then
      warn "Remote Application Scripting is on"
    fi

    if cupsctl | grep -qx '_share_printers=1'; then
      warn "Printer Sharing is on"
    fi

    nat=$(/usr/libexec/PlistBuddy -c 'Print :NAT:Enabled' \
      /Library/Preferences/SystemConfiguration/com.apple.nat.plist 2>/dev/null || true)
    if [[ $nat == 1 || $nat == true ]]; then
      warn "Internet Sharing is on"
    fi

    # home-sharing-enabled is Unverified: Home Sharing needs an Apple Account
    for key in public-sharing-enabled home-sharing-enabled; do
      if [[ $(${asUser} defaults read com.apple.amp.mediasharingd "$key" 2>/dev/null || true) == 1 ]]; then
        warn "Media Sharing is on"
        break
      fi
    done

    # Unverified: content caching can't be turned on in a VM
    if AssetCacheManagerUtil isActivated >/dev/null 2>&1; then
      warn "Content Caching is on"
    fi
  '';
}
