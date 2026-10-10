{ inputs }:

name:
{
  system,
  user,
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

    ../machines/${name}.nix

    homeManagerModule
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "before-home-manager";
    }

    {
      _module.args = {
        currentSystemName = name;
        currentSystemUser = user;
      };
    }
  ];
}
