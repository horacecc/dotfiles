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
      _FXSortFoldersFirst = false;
      _FXSortFoldersFirstOnDesktop = false;
      QuitMenuItem = true;

      ShowHardDrivesOnDesktop = true;
      ShowExternalHardDrivesOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      ShowMountedServersOnDesktop = true;

      FXEnableExtensionChangeWarning = false;
      FXRemoveOldTrashItems = true;
    };

    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain."com.apple.springing.enabled" = true;
    NSGlobalDomain."com.apple.springing.delay" = 0.5;

    CustomUserPreferences."com.apple.finder" = {
      DisableAllAnimations = true;
      ShowSidebar = true;
      ShowRecentTags = false;
      # Removes every tag from the sidebar and menus; the tags themselves stay
      FavoriteTagNames = [ "" ];
      WarnOnEmptyTrash = false;
      FXInfoPanesExpanded = {
        General = true;
        OpenWith = true;
        Privileges = true;
      };

      # Mounting shouldn't render untrusted files before I choose to open them
      OpenWindowForNewRemovableDisk = false;
    };

    # Turns off the warning when moving items out of iCloud Drive
    CustomUserPreferences."com.apple.bird"."com.apple.clouddocs.unshared.moveOut.suppress" = true;

    CustomUserPreferences."com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };

    # Mounting shouldn't render untrusted files before I choose to open them
    CustomUserPreferences."com.apple.frameworks.diskimages" = {
      auto-open-ro-root = false;
      auto-open-rw-root = false;
    };
  };
}
