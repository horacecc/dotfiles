# 把一台機器組合起來：機器本身的設定 + 使用者的系統設定 + 使用者的 home-manager 設定
{ inputs }:

name:
{
  system,
  user,
  profile ? user,
  darwin ? false,
}:

let
  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
  homeManagerModule =
    if darwin then
      inputs.home-manager.darwinModules.home-manager
    else
      inputs.home-manager.nixosModules.home-manager;
  userOSConfig = if darwin then "darwin.nix" else "nixos.nix";
in
systemFunc {
  modules = [
    { nixpkgs.hostPlatform = system; }

    ../machines/${name}.nix
    ../users/${profile}/${userOSConfig}

    homeManagerModule
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "before-home-manager";
      home-manager.users.${user} = import ../users/${profile}/home-manager.nix;
    }

    {
      _module.args = {
        currentSystemName = name;
        currentSystemUser = user;
      };
    }
  ];
}
