{
  description = "h's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nixpkgs-unstable,
    }@inputs:
    let
      overlays = [
        # The system stays on stable; a package that stable lacks, or has too old
        # or broken, comes from pkgs.unstable instead
        (final: prev: {
          unstable = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
        })
      ];

      mkSystem = import ./lib/mksystem.nix { inherit inputs overlays; };
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
