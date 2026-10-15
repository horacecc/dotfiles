{
  # power.sleep.computer would also keep a laptop awake on battery
  system.activationScripts.postActivation.text = ''
    pmset -c sleep 0

    # The screen locks when the display sleeps, so this bounds how long an
    # unattended Mac stays unlocked
    pmset -c displaysleep 30
    # Unverified: the VM has no battery, and pmset ignores -b there
    pmset -b displaysleep 5
  '';
}
