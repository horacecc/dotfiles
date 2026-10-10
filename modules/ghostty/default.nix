{ lib, isDarwin, ... }:
{
  home-manager.sharedModules = [
    {
      xdg.configFile."ghostty/config".source = ./config;

      # Ghostty injects it through XDG_DATA_DIRS, which nix-darwin overwrites
      programs.fish.interactiveShellInit = ''
        if set -q GHOSTTY_RESOURCES_DIR; and not functions -q __ghostty_setup; and not functions -q __ghostty_mark_prompt_start
          set -l ghostty_fish "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
          test -r $ghostty_fish; and source $ghostty_fish
        end
      '';
    }
  ];
}
// lib.optionalAttrs isDarwin {
  homebrew.casks = [ "ghostty" ];
}
