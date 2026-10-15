{
  system.defaults.NSGlobalDomain.AppleICUForce24HourTime = true;
  # System Settings writes both keys, so a leftover 12-hour override can't win
  system.defaults.CustomUserPreferences.NSGlobalDomain.AppleICUForce12HourTime = false;
}
