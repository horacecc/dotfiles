{
  system.defaults = {
    finder = {
      NewWindowTarget = "Home";
      # Nlsv is list view
      FXPreferredViewStyle = "Nlsv";
      # SCcf searches the current folder
      FXDefaultSearchScope = "SCcf";
      AppleShowAllFiles = true;
      ShowStatusBar = true;
      ShowPathbar = true;
      _FXShowPosixPathInTitle = true;
      QuitMenuItem = true;
    };
    NSGlobalDomain.AppleShowAllExtensions = true;
    CustomUserPreferences."com.apple.finder".DisableAllAnimations = true;
  };
}
