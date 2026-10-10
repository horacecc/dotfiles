
{ lib, ... }:
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

    WindowManager.StandardHideWidgets = true;
    WindowManager.StageManagerHideWidgets = true;
    # 1 is never
    CustomUserPreferences."com.apple.widgets".widgetAppearance = 1;
    # Unverified: the toggle only appears when signed in to an Apple Account with an iPhone
    CustomUserPreferences."com.apple.chronod".remoteWidgetsEnabled = false;
    CustomUserPreferences."com.apple.chronod".effectiveRemoteWidgetsEnabled = false;

    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    # Unverified: the VM has no trackpad
    trackpad.Clicking = true;
    # Despite the name, this enables tap to click on the trackpad
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    trackpad.TrackpadRightClick = true;
    trackpad.TrackpadCornerSecondaryClick = 0;

    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    # Faster than the System Settings sliders allow; units are 15 ms
    NSGlobalDomain.InitialKeyRepeat = 10;
    NSGlobalDomain.KeyRepeat = 1;
    NSGlobalDomain."com.apple.keyboard.fnState" = true;

    # Replaces the whole dictionary; IDs left out fall back to their macOS defaults
    CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys =
      lib.genAttrs [
        "7" "8" "9" "10" "11" "12" "13" "15" "16" "17" "18" "19" "20" "21"
        "22" "23" "24" "25" "26" "28" "29" "30" "31" "32" "33" "36" "52" "53"
        "54" "57" "59" "61" "64" "65" "79" "80" "81" "82" "118" "159" "162"
        "164" "175" "190" "215" "216" "217" "218" "219" "222" "223" "224"
        "225" "226" "227" "228" "229" "230" "231" "232" "233" "235" "237"
        "238" "239" "240" "241" "242" "243" "244" "245" "246" "247" "248"
        "249" "250" "251" "256" "257" "258" "260"
      ] (_: { enabled = false; })
      // {
        # parameters: character code, key code, modifier mask (Option 524288, Control 262144, Command 1048576)
        "27" = { enabled = true; value = { type = "standard"; parameters = [ 65535 48 524288 ]; }; };
        "60" = { enabled = true; value = { type = "standard"; parameters = [ 32 49 262144 ]; }; };
        "160" = { enabled = true; value = { type = "standard"; parameters = [ 32 49 1048576 ]; }; };
      };
  };

  system.startup.chime = false;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
}
