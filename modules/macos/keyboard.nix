{
  system.defaults = {
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    # Faster than the System Settings sliders allow; units are 15 ms
    NSGlobalDomain.InitialKeyRepeat = 10;
    NSGlobalDomain.KeyRepeat = 1;
    NSGlobalDomain."com.apple.keyboard.fnState" = true;
  };

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
}
