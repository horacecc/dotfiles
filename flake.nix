{
  description = "h 的系統設定";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager }@inputs:
    let
      mkSystem = import ./lib/mksystem.nix { inherit inputs; };
    in
    {
      darwinConfigurations.utm = mkSystem "utm" {
        system = "aarch64-darwin";
        user = "h";
        darwin = true;
      };
    };
}
