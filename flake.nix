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

      # Named by each machine's hostname, which darwin-rebuild and nixos-rebuild
      # pick when given no name; file is the machine's file in machines/
      machines = {
        mac = {
          file = "macbook-pro-m2-max";
          system = "aarch64-darwin";
          user = "h";
        };
        utm = {
          file = "mac-utm";
          system = "aarch64-darwin";
          user = "h";
        };
      };

      isDarwin = machine: nixpkgs.lib.hasSuffix "-darwin" machine.system;
      mkMachine =
        hostname: machine:
        mkSystem machine.file {
          inherit hostname;
          inherit (machine) system user;
          darwin = isDarwin machine;
        };
      machinesWhere =
        predicate: builtins.mapAttrs mkMachine (nixpkgs.lib.filterAttrs (_: predicate) machines);
    in
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;

      darwinConfigurations = machinesWhere isDarwin;
      nixosConfigurations = machinesWhere (machine: !isDarwin machine);
    };
}
