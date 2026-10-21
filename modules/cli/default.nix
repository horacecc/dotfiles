{ pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      home.packages = [
        pkgs._7zz
        pkgs.age
        pkgs.exiftool
        pkgs.rclone
        # Not in the stable nixpkgs yet
        pkgs.unstable.hunk
      ];
    }
  ];
}
