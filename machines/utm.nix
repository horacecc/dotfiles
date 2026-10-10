# The macOS VM in UTM, and the modules it uses
{ ... }:
{
  imports = [
    ./darwin-shared.nix
    ../modules/fish
    ../modules/ghostty
    ../modules/git
    ../modules/hushlogin
    ../modules/op
    ../modules/xdg
  ];
}
