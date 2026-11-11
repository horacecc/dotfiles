{
  # Installing macOS updates restarts the Mac on its own
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

  system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.SoftwareUpdate" = {
    AutomaticCheckEnabled = true;
    AutomaticDownload = true;
    CriticalUpdateInstall = true;
    # System data files such as XProtect definitions
    ConfigDataInstall = true;
  };

  # So the updates left to install by hand aren't forgotten. --no-scan lists what
  # the last background check found, without the network. A new major macOS is
  # only mentioned, so staying on this one doesn't warn on every switch
  system.activationScripts.postActivation.text = ''
    currentMajor=$(sw_vers -productVersion)
    currentMajor=''${currentMajor%%.*}
    updates=0
    newMajor=
    updateRe='Title: (.*), Version: ([0-9]+)'
    while IFS= read -r line; do
      [[ $line =~ $updateRe ]] || continue
      if [[ ''${BASH_REMATCH[1]} == macOS* ]] && (( BASH_REMATCH[2] > currentMajor )); then
        newMajor=''${BASH_REMATCH[1]}
      else
        updates=$((updates + 1))
      fi
    done < <(softwareupdate --list --no-scan 2>/dev/null || true)
    if (( updates > 0 )); then
      warn "$updates software update(s) to install in System Settings > General > Software Update"
    fi
    if [[ -n $newMajor ]]; then
      echo "$newMajor is available in System Settings > General > Software Update"
    fi
  '';
}
