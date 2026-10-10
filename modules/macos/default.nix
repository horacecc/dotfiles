{
  system.defaults = {
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.NSTableViewDefaultSizeMode = 1;
    NSGlobalDomain.AppleShowScrollBars = "Always";

    CustomUserPreferences.NSGlobalDomain = {
      # 4 is blue; without this key macOS uses multicolor
      AppleAccentColor = 4;
      AppleHighlightColor = "0.698039 0.843137 1.000000 Blue";
    };
  };
  system.startup.chime = false;
}
