{
  # Installing macOS updates restarts the Mac on its own
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

  system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.SoftwareUpdate" = {
    AutomaticCheckEnabled = true;
    AutomaticDownload = true;
    CriticalUpdateInstall = true;
    # System data files such as XProtect definitions
    ConfigDataInstall = true;
  };
}
