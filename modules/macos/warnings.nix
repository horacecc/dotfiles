{ lib, ... }:
{
  # Warnings scroll by among the rest of the switch output, so they're colored
  # and repeated at the end
  system.activationScripts.postActivation.text = lib.mkMerge [
    (lib.mkBefore ''
      switchWarnings=()
      warn() {
        printf '\033[1;33mwarning:\033[0m %s\n' "$1" >&2
        switchWarnings+=("$1")
      }
    '')
    (lib.mkAfter ''
      if (( ''${#switchWarnings[@]} > 0 )); then
        printf '\n\033[1;33m%d warning(s) during the switch:\033[0m\n' "''${#switchWarnings[@]}" >&2
        printf '  - %s\n' "''${switchWarnings[@]}" >&2
      fi
    '')
  ];
}
