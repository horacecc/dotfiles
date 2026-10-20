{
  system.defaults.CustomUserPreferences = {
    # 2 means opted out
    "com.apple.assistant.support"."Siri Data Sharing Opt-In Status" = 2;
    # System Settings stores this switch as an integer
    "com.apple.Accessibility".AXSAudioDonationSiriImprovementEnabled = 0;

    # Unverified: System Settings has no switch for these
    "com.apple.AdLib" = {
      allowApplePersonalizedAdvertising = false;
      allowIdentifierForAdvertising = false;
    };
  };

  # CustomSystemPreferences doesn't quote the domain, and this path has a space
  system.activationScripts.postActivation.text = ''
    defaults write "/Library/Application Support/CrashReporter/DiagnosticMessagesHistory" AutoSubmit -bool false
    defaults write "/Library/Application Support/CrashReporter/DiagnosticMessagesHistory" ThirdPartyDataSubmit -bool false
  '';
}
