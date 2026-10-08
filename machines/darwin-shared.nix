# 每台 Mac 共用的系統設定
{ pkgs, ... }:
{
  nix.enable = false;
  system.stateVersion = 6;

  environment.systemPackages = [
    pkgs.tree
  ];
}
