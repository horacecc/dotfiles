{
  system.defaults = {
    NSGlobalDomain.NSUseAnimatedFocusRing = false;
    NSGlobalDomain.NSScrollAnimationEnabled = true;
    NSGlobalDomain.NSWindowResizeTime = 0.001;
    CustomUserPreferences.NSGlobalDomain.NSToolbarTitleViewRolloverDelay = 0.0;

    CustomUserPreferences.NSGlobalDomain.NSQuitAlwaysKeepsWindows = false;
    CustomUserPreferences.NSGlobalDomain.NSCloseAlwaysConfirmsChanges = false;
    NSGlobalDomain.NSDisableAutomaticTermination = true;
    NSGlobalDomain.AppleWindowTabbingMode = "fullscreen";

    WindowManager.EnableTilingByEdgeDrag = true;
    WindowManager.EnableTopTilingByEdgeDrag = true;
    WindowManager.EnableTilingOptionAccelerator = true;
    WindowManager.EnableTiledWindowMargins = false;

    WindowManager.GloballyEnabled = false;
    WindowManager.AutoHide = true;
    # true shows all of an app's windows at once
    WindowManager.AppWindowGroupingBehavior = true;
    # false reveals the desktop on a wallpaper click only in Stage Manager
    WindowManager.EnableStandardClickToShowDesktop = false;
    WindowManager.StandardHideDesktopIcons = true;
    WindowManager.HideDesktop = true;
  };
}
