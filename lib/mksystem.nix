# 把一台機器組合起來：機器本身的設定（含它要的 modules）+ home-manager
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
  # Known before the modules are evaluated, so modules can use it to decide
  # which options to set (pkgs.stdenv.isDarwin there is an infinite recursion)
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
