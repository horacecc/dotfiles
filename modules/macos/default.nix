{
  # Values matching the current macOS defaults are pinned so an update can't change them
  system.defaults = {
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    # 4 is blue; without this key macOS uses multicolor
    CustomUserPreferences.NSGlobalDomain.AppleAccentColor = 4;
    CustomUserPreferences.NSGlobalDomain.AppleHighlightColor = "0.698039 0.843137 1.000000 Blue";
    NSGlobalDomain.NSTableViewDefaultSizeMode = 1;
    NSGlobalDomain.AppleShowScrollBars = "Always";

    NSGlobalDomain.NSUseAnimatedFocusRing = false;
    NSGlobalDomain.NSScrollAnimationEnabled = true;
    NSGlobalDomain.NSWindowResizeTime = 0.001;
    CustomUserPreferences.NSGlobalDomain.NSToolbarTitleViewRolloverDelay = 0.0;

    # Older macOS reads the key without the 2
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
    CustomUserPreferences."com.apple.print.PrintingPrefs"."Quit When Finished" = true;
  };

  system.startup.chime = false;
}
