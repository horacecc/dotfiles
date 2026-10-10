{
  lib,
  pkgs,
  isDarwin,
  currentSystemUser,
  ...
}:
let
  opener = if isDarwin then "open" else "xdg-open";
in
{
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  home-manager.sharedModules = [
    {
      programs.fish = {
        enable = true;
        shellInit = builtins.readFile ./env.fish;
        interactiveShellInit = builtins.readFile ./interactive.fish;
        shellAbbrs = {
          cls = "clear";
        };
        shellAliases = {
          tre = "tree -aC -I '.git|node_modules|bower_components' --dirsfirst";
        };
        binds = {
          "ctrl-y".command = "accept-autosuggestion";
          # Esc Esc pressed quickly arrives as alt-escape
          "escape,escape".command = "fish_commandline_prepend sudo";
          "alt-escape".command = "fish_commandline_prepend sudo";
        };
        functions = {
          fish_should_add_to_history = ''
            # fish skips commands with a leading space only without this function
            string match -q -- ' *' $argv[1]; and return 1
            not string match -qr '^\s*(ls|cd|pwd|exit|cd \.\.)\s*$' -- $argv[1]
          '';
          tren = {
            description = "tre, paged through less with line numbers";
            wraps = "tree";
            body = "tre $argv | less -FRNX";
          };
          o = {
            description = "Open the arguments, or the current directory";
            wraps = opener;
            body = ''
              if test (count $argv) -eq 0
                ${opener} .
              else
                ${opener} $argv
              end
            '';
          };
        };
        plugins = [ ];
      };
      xdg.configFile."fish/functions/fish_prompt.fish".source = ./fish_prompt.fish;
    }
  ];
}
// lib.optionalAttrs isDarwin {
  # users.users.<name>.shell needs users.knownUsers, which nix-darwin says not
  # to use for the admin account
  system.activationScripts.postActivation.text = ''
    fish=/run/current-system/sw/bin/fish
    if [ "$(dscl . -read /Users/${currentSystemUser} UserShell | cut -d' ' -f2)" != "$fish" ]; then
      echo "setting the login shell of ${currentSystemUser} to $fish..." >&2
      dscl . -create /Users/${currentSystemUser} UserShell "$fish"
    fi
  '';
}
