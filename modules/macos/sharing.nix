{
  # Sharing is turned on by hand when it's needed, so a switch only warns about it
  system.activationScripts.postActivation.text = ''
    if launchctl print system/com.openssh.sshd >/dev/null 2>&1; then
      echo "warning: Remote Login is on" >&2
    fi
  '';
}
