{
  # Values matching the current macOS defaults are pinned so an update can't change them
  system.defaults = {
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.NSTableViewDefaultSizeMode = 1;
    NSGlobalDomain.AppleShowScrollBars = "Always";
    NSGlobalDomain.NSUseAnimatedFocusRing = false;
    NSGlobalDomain.NSScrollAnimationEnabled = true;

    CustomUserPreferences.NSGlobalDomain = {
      # 4 is blue; without this key macOS uses multicolor
      AppleAccentColor = 4;
      AppleHighlightColor = "0.698039 0.843137 1.000000 Blue";
      NSToolbarTitleViewRolloverDelay = 0.0;
    };
  };
  system.startup.chime = false;
}
