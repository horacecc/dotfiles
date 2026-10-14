{
  # Turning FileVault on needs the user's password and a decision on the recovery
  # key, so a switch only warns about it
  system.activationScripts.postActivation.text = ''
    # Unverified: FileVault wasn't turned on in the VM
    if [[ $(fdesetup status) != "FileVault is On."* ]]; then
      echo "warning: FileVault is off" >&2
    fi
  '';
}
