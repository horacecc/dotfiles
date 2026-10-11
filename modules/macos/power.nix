{
  # power.sleep.computer would also keep a laptop awake on battery
  system.activationScripts.postActivation.text = ''
    pmset -c sleep 0
  '';
}
