# ~/.hushlogin：登入時不顯示「Last login」
{
  home-manager.sharedModules = [
    {
      # Copied into the Nix store; changes need a switch
      home.file.".hushlogin".source = ./hushlogin;
    }
  ];
}
