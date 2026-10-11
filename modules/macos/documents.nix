{
  system.defaults = {
    # Older macOS reads the key without the 2
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
    CustomUserPreferences."com.apple.print.PrintingPrefs"."Quit When Finished" = true;

    CustomUserPreferences."com.apple.TextEdit" = {
      RichText = false;
      # 4 is UTF-8
      PlainTextEncoding = 4;
      PlainTextEncodingForWrite = 4;
    };
  };
}
