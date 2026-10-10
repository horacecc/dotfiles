{ lib, ... }:
{
  system.defaults = {

    # Replaces the whole dictionary; IDs left out fall back to their macOS defaults
    CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys =
      lib.genAttrs [
        "7" "8" "9" "10" "11" "12" "13" "15" "16" "17" "18" "19" "20" "21"
        "22" "23" "24" "25" "26" "28" "29" "30" "31" "32" "33" "36" "52" "53"
        "54" "57" "59" "61" "64" "65" "79" "80" "81" "82" "118" "159" "162"
        "164" "175" "190" "215" "216" "217" "218" "219" "222" "223" "224"
        "225" "226" "227" "228" "229" "230" "231" "232" "233" "235" "237"
        "238" "239" "240" "241" "242" "243" "244" "245" "246" "247" "248"
        "249" "250" "251" "256" "257" "258" "260"
      ] (_: { enabled = false; })
      // {
        # parameters: character code, key code, modifier mask (Option 524288, Control 262144, Command 1048576)
        "27" = { enabled = true; value = { type = "standard"; parameters = [ 65535 48 524288 ]; }; };
        "60" = { enabled = true; value = { type = "standard"; parameters = [ 32 49 262144 ]; }; };
        "160" = { enabled = true; value = { type = "standard"; parameters = [ 32 49 1048576 ]; }; };
      };

    # Replaces the whole dictionary; services left out fall back to their macOS defaults
    CustomUserPreferences.pbs.NSServicesStatus =
      lib.genAttrs [
        "com.apple.ChineseTextConverterService - Convert Text from Simplified to Traditional Chinese - convertTextToTraditionalChinese"
        "com.apple.ChineseTextConverterService - Convert Text from Traditional to Simplified Chinese - convertTextToSimplifiedChinese"
        "com.apple.ChineseTextConverterService - Convert Text to Full Width - convertTextToFullWidth"
        "com.apple.ChineseTextConverterService - Convert Text to Half Width - convertTextToHalfWidth"
        "com.apple.Dictionary - Look Up in Dictionary - doLookupService"
        "com.apple.finder - Finder/Open - open"
        "com.apple.finder - Finder/Reveal - reveal"
        "com.apple.finder - Finder/Show Info - showInfo"
        "com.apple.FolderActionsSetup - Folder Actions Setup - openFilesFromPasteboard"
        "com.apple.mail - Mail/New Email To Address - mailTo"
        "com.apple.mail - Mail/New Email With Selection - mailSelection"
        "com.apple.QuickTime.service.encodeSelectedAudioFiles - Encode Selected Audio Files - runWorkflowAsService"
        "com.apple.Safari - Add to Reading List - addToReadingList"
        "com.apple.Safari - Search With %WebSearchProvider@ - searchWithWebSearchProvider"
        "com.apple.services.addToiTunesAsSpokenTrack - Add to Music as a Spoken Track - runWorkflowAsService"
        "com.apple.services.encodeSelectedVideoFiles - Encode Selected Video Files - runWorkflowAsService"
        "com.apple.services.setDesktopPicture - Set Desktop Picture - runWorkflowAsService"
        "com.apple.services.showMap - Show Map - runWorkflowAsService"
        "com.apple.Stickies - Make Sticky - makeStickyFromTextService"
        "com.apple.systemuiserver - Open URL - openURL"
        "com.apple.Terminal - New Terminal at Folder - newTerminalAtFolder"
        "com.apple.Terminal - New Terminal Tab at Folder - newTerminalAtFolder"
        "com.apple.Terminal - Open man Page in Terminal - openManPage"
        "com.apple.Terminal - Search man Page Index in Terminal - searchManPages"
        "com.mitchellh.ghostty - New Ghostty Tab Here - openTab"
        "com.mitchellh.ghostty - New Ghostty Window Here - openWindow"
      ] (_: {
        enabled_context_menu = false;
        enabled_services_menu = false;
        presentation_modes = { ContextMenu = false; ServicesMenu = false; };
      });
  };
}
