{
  description = "h's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
    }@inputs:
    let
      mkSystem = import ./lib/mksystem.nix { inherit inputs; };
    in
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;

      darwinConfigurations.mac = mkSystem "mac" {
        system = "aarch64-darwin";
        user = "h";
        darwin = true;
      };

      darwinConfigurations.utm = mkSystem "utm" {
        system = "aarch64-darwin";
        user = "h";
        darwin = true;
      };
    };
}
