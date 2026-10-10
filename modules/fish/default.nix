# fish: the login shell, configured by home-manager
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
      # home-manager writes config.fish from our two files, and wires in plugins
      # and other programs' hooks (direnv, atuin, ...) when we add them
      programs.fish = {
        enable = true;
        shellInit = builtins.readFile ./env.fish;
        interactiveShellInit = builtins.readFile ./interactive.fish;
        # Abbreviations expand as you type, so history keeps the real command
        shellAbbrs = {
          cls = "clear";
        };
        # Helper commands. Aliases and functions complete like the command they wrap.
        shellAliases = {
          tre = "tree -aC -I '.git|node_modules|bower_components' --dirsfirst";
        };
        # Written to functions/fish_user_key_bindings.fish, the function fish
        # runs to load the user's key bindings
        binds = {
          # ^Y accepts the autosuggestion (→ and ^F still work)
          "ctrl-y".command = "accept-autosuggestion";
          # Esc Esc toggles sudo in front of the line, or the previous command (Alt-S does too).
          # Pressed quickly, the two escapes arrive as alt-escape, so bind both.
          "escape,escape".command = "fish_commandline_prepend sudo";
          "alt-escape".command = "fish_commandline_prepend sudo";
        };
        # Each one is written to functions/<name>.fish and loaded when first used
        functions = {
          # Don't save these to history
          fish_should_add_to_history = ''
            # A leading space keeps a command out of history, as fish does without this function
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
        plugins = [
          # Pinned by flake.lock, e.g.:
          # { name = "done"; src = pkgs.fishPlugins.done.src; }
        ];
      };
      xdg.configFile."fish/functions/fish_prompt.fish".source = ./fish_prompt.fish;
    }
  ];
}
// lib.optionalAttrs isDarwin {
  # nix-darwin only sets users.users.<name>.shell for users it fully manages
  # (users.knownUsers), which it says not to do for the admin account, so
  # allow fish in /etc/shells (above) and set the login shell ourselves.
  system.activationScripts.postActivation.text = ''
    fish=/run/current-system/sw/bin/fish
    if [ "$(dscl . -read /Users/${currentSystemUser} UserShell | cut -d' ' -f2)" != "$fish" ]; then
      echo "setting the login shell of ${currentSystemUser} to $fish..." >&2
      dscl . -create /Users/${currentSystemUser} UserShell "$fish"
    fi
  '';
}
