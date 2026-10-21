{ lib, isDarwin, ... }:
lib.optionalAttrs isDarwin {
  # nixpkgs only packages GnuPG 2.4, which reached end of life on 2026-06-30
  homebrew.brews = [ "gnupg" ];
}
