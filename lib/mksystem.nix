{ inputs, overlays }:

name:
{
  system,
  user,
  # The computer's name on the network, which can differ from the file in machines/
  hostname,
  # The hardware the configuration is for, which activation checks before changing anything
  model,
  darwin ? false,
}:

let
  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
  homeManagerModule =
    if darwin then
      inputs.home-manager.darwinModules.home-manager
    else
      inputs.home-manager.nixosModules.home-manager;
in
systemFunc {
  # pkgs.stdenv.isDarwin can't decide which options a module sets: infinite recursion
  specialArgs = {
    isDarwin = darwin;
  };

  modules = [
    { nixpkgs.hostPlatform = system; }
    { nixpkgs.overlays = overlays; }

    ../machines/${name}.nix

    homeManagerModule
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "before-home-manager";
    }

    {
      _module.args = {
        currentSystemName = hostname;
        currentSystemModel = model;
        currentSystemUser = user;
      };
    }
  ];
}
