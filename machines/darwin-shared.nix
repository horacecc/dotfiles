{
  lib,
  pkgs,
  currentSystemName,
  currentSystemModel,
  currentSystemUser,
  ...
}:
let
  homebrewEnv = {
    HOMEBREW_NO_ANALYTICS = "1";
    # Refuse a download that an HTTPS URL redirects to plain HTTP
    HOMEBREW_NO_INSECURE_REDIRECT = "1";
    # Refuse a cask without a checksum, also when an upgrade drops it;
    # homebrew.caskArgs.require_sha would only apply to installs
    HOMEBREW_CASK_OPTS = "--require-sha";
  };
in
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # The flake pins nixpkgs, so a channel would only add an unpinned second source
  nix.channel.enable = false;

  # Off by default on macOS, which lets a build read and write outside its inputs
  nix.settings.sandbox = true;
  # Fail instead of quietly building without the sandbox
  nix.settings.sandbox-fallback = false;

  # bootstrap.sh adds the two settings above to the installer's nix.conf, which
  # changes its hash from the ones nix-darwin knows
  environment.etc."nix/nix.conf".knownSha256Hashes = [
    "1693af3f15d76baa1fa22ea17d65d90f05483615e2cd38c7dd0d97eb9cadca3b"
  ];

  # Trusted users can choose substituters and import unsigned paths, which is root
  # access; mkForce so neither a changed default nor another module can widen it
  nix.settings.trusted-users = lib.mkForce [ "root" ];

  # The 2.34 install script adds its block at the top of these files, which
  # nix-darwin doesn't recognize yet
  environment.etc."zshrc".knownSha256Hashes = [
    "cf0f7b7775b4c058d6085d9e7e57d58c307ca43730f8e4d921a9ef4e530e7e16"
  ];
  environment.etc."bashrc".knownSha256Hashes = [
    "8b5e3466922d1ae34bc145e21c7e53e7329a7a7b58b148b436bd954d5e651ac3"
  ];

  system.stateVersion = 6;
  home-manager.users.${currentSystemUser}.home.stateVersion = "26.05";

  system.primaryUser = currentSystemUser;
  users.users.${currentSystemUser}.home = "/Users/${currentSystemUser}";
  networking.computerName = currentSystemName;
  networking.hostName = currentSystemName;

  # Renaming the computer makes macOS rewrite this plist with the old name, so a rename needs a second switch
  system.defaults.smb.NetBIOSName = currentSystemName;

  # darwin-rebuild picks the configuration by hostname, which anything can change;
  # checks run before activation changes anything
  system.checks.text = ''
    expectedModel=${lib.escapeShellArg currentSystemModel}
    actualModel=$(/usr/sbin/sysctl -n hw.model)
    if [[ $actualModel != "$expectedModel" ]]; then
      printf >&2 '\e[1;31merror: this configuration is for a %s, not this %s\e[0m\n' \
        "$expectedModel" "$actualModel"
      exit 2
    fi
  '';

  environment.systemPackages = [
    pkgs.tree
  ];

  environment.variables = homebrewEnv;

  homebrew = {
    enable = true;
    onActivation = {
      # Without it the switch installs from a stale package list
      autoUpdate = true;
      # Also upgrades a self-updating cask whose app hasn't updated itself since it was installed
      upgrade = true;
      cleanup = "uninstall";
      # Activation runs brew under sudo, which doesn't pass on environment.variables
      extraEnv = homebrewEnv;
    };
  };
}
