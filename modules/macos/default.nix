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

    CustomUserPreferences.NSGlobalDomain.NSQuitAlwaysKeepsWindows = false;
    NSGlobalDomain.NSDisableAutomaticTermination = true;

    NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
    NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    NSGlobalDomain.NSAutomaticInlinePredictionEnabled = true;

    CustomUserPreferences."com.apple.TextInputMenu".visible = false;
    # 0 stops Caps Lock from switching between ABC and the current input source
    CustomUserPreferences.NSGlobalDomain.TISRomanSwitchState = 0;
    CustomUserPreferences."com.apple.HIToolbox".AppleGlobalTextInputProperties.TextInputGlobalPropertyPerContextInput = 1;
    # 0 is horizontal
    CustomUserPreferences."com.apple.inputmethod.CoreChineseEngineFramework".ZhuyinCandidateWindowDirection = 0;
    CustomUserPreferences."com.apple.inputmethod.CoreChineseEngineFramework".FontSize = 16;
  };

  system.startup.chime = false;
}
