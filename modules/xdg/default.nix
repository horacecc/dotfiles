# XDG 基本目錄：匯出 XDG_CONFIG_HOME 等環境變數
{
  home-manager.sharedModules = [
    {
      # Exports XDG_CONFIG_HOME (~/.config) and the other XDG_*_HOME through
      # hm-session-vars, so tools on macOS look in ~/.config instead of
      # ~/Library/Application Support
      xdg.enable = true;
    }
  ];
}
