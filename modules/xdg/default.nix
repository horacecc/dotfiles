# XDG base directories: exports XDG_CONFIG_HOME and the rest
{
  home-manager.sharedModules = [
    {
      # Exports XDG_CONFIG_HOME (~/.config) and the other XDG_*_HOME through
      # hm-session-vars, so tools on macOS look in ~/.config instead of
      # ~/Library/Application Support
      xdg.enable = true;
    }
  ];
}
