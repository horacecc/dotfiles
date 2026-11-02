{
  # Turning FileVault on needs the user's password and a decision on the recovery
  # key, so a switch only warns about it
  system.activationScripts.postActivation.text = ''
    if [[ $(fdesetup status) != "FileVault is On."* ]]; then
      warn "FileVault is off"
    fi
  '';
}
