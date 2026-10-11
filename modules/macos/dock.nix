{
  # nix-darwin restarts the Dock on every switch for system.defaults.dock, and the
  # restarted Dock drops the custom Show Apps shortcut until the next login
  system.defaults.CustomUserPreferences."com.apple.dock" = {
    tilesize = 25;
    magnification = false;
    orientation = "left";
    autohide = true;
    autohide-delay = 0.0;
    autohide-time-modifier = 0.0;

    static-only = true;
    show-recents = false;
    show-process-indicators = true;
    showhidden = true;
    mineffect = "scale";
    minimize-to-application = true;
    launchanim = false;
    enable-spring-load-actions-on-all-items = true;

    expose-animation-duration = 0.1;
    # Renamed from expose-group-by-app, which macOS no longer reads
    expose-group-apps = false;
    mru-spaces = false;
    enterMissionControlByTopWindowDrag = false;
    # Unverified: the VM has no trackpad
    showLaunchpadGestureEnabled = true;
  };

  system.defaults.NSGlobalDomain.AppleSpacesSwitchOnActivate = false;
  # false means each display gets its own Spaces
  system.defaults.spaces.spans-displays = false;
}
