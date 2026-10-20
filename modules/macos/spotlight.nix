{
  system.defaults.CustomUserPreferences = {
    # Despite its name, this lists the categories that are turned off. Apps
    # left out, such as ones installed later, still show up in results
    "com.apple.Spotlight".EnabledPreferenceRules = [
      # Related content sends the search to Apple
      "Custom.relatedContents"
      "System.menuItems"
      "System.files"
      "System.folders"
      "System.iphoneApps"
      "com.apple.iCal"
      "com.apple.systempreferences"
      "com.apple.stocks"
      "com.apple.calculator"
      "com.apple.iBooksX"
      "com.apple.shortcuts"
      "com.apple.Notes"
      "com.apple.tips"
      "com.apple.reminders"
      "com.apple.mail"
      "com.apple.Photos"
      "com.apple.VoiceMemos"
      "com.apple.AddressBook"
      "com.apple.Dictionary"
      "com.apple.AppStore"
      "com.apple.podcasts"
      "com.apple.Safari"
    ];
    "com.apple.Spotlight".PasteboardHistoryEnabled = false;

    # 2 means opted out
    "com.apple.assistant.support"."Search Queries Data Sharing Status" = 2;
  };
}
