{
  description = "h 的系統設定";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin }: {
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
      ];
    };
  };
}
