{
  lib,
  pkgs,
  currentSystemName,
  currentSystemUser,
  ...
}:
let
  homebrewEnv = {
    HOMEBREW_NO_ANALYTICS = "1";
    # Refuse a download that an HTTPS URL redirects to plain HTTP
    HOMEBREW_NO_INSECURE_REDIRECT = "1";
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

  environment.systemPackages = [
    pkgs.tree
  ];

  environment.variables = homebrewEnv;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
      # Activation runs brew under sudo, which doesn't pass on environment.variables
      extraEnv = homebrewEnv;
    };
  };
}
