{
  home-manager.sharedModules = [
    {
      # Without XDG_CONFIG_HOME, some tools on macOS use ~/Library/Application Support
      xdg.enable = true;
    }
  ];
}
