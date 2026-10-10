{
  system.defaults = {
    WindowManager.StandardHideWidgets = true;
    WindowManager.StageManagerHideWidgets = true;
    # 1 is never
    CustomUserPreferences."com.apple.widgets".widgetAppearance = 1;
    # Unverified: the toggle only appears when signed in to an Apple Account with an iPhone
    CustomUserPreferences."com.apple.chronod".remoteWidgetsEnabled = false;
    CustomUserPreferences."com.apple.chronod".effectiveRemoteWidgetsEnabled = false;
  };
}
