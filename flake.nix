{
  description = "h 的系統設定";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager }: {
    darwinConfigurations.utm = nix-darwin.lib.darwinSystem {
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.hostPlatform = "aarch64-darwin";
          nix.enable = false;
          system.stateVersion = 6;

          environment.systemPackages = [
            pkgs.tree
          ];

          system.primaryUser = "h";

          homebrew = {
            enable = true;
            onActivation = {
              autoUpdate = false;
              upgrade = false;
              cleanup = "uninstall";
            };
            casks = [
              "ghostty"
            ];
          };
        })

        {
          homebrew.casks = [
            "1password-cli"
          ];
        }

        home-manager.darwinModules.home-manager
        {
          users.users.h.home = "/Users/h";

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "before-home-manager";
          home-manager.users.h = import ./home.nix;
        }
      ];
    };
  };
}
