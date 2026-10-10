# UTM 裡的 macOS 虛擬機
{ ... }:
{
  imports = [
    ./darwin-shared.nix
    ../modules/ghostty
    ../modules/git
    ../modules/hushlogin
    ../modules/op
  ];
}
