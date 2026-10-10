{
  system.defaults = {
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
}
