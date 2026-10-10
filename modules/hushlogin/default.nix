{
  home-manager.sharedModules = [
    {
      home.file.".hushlogin".source = ./hushlogin;
    }
  ];
}
