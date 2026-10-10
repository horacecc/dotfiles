# 1Password CLI：安裝
{ lib, isDarwin, ... }:
lib.optionalAttrs isDarwin {
  homebrew.casks = [ "1password-cli" ];
}
