{
  # These are only turned off by hand, and SIP only from Recovery, so a switch only warns
  system.activationScripts.postActivation.text = ''
    if [[ $(spctl --status 2>&1) != "assessments enabled" ]]; then
      echo "warning: Gatekeeper is off" >&2
    fi

    if [[ $(csrutil status 2>&1) != *"status: enabled."* ]]; then
      echo "warning: System Integrity Protection is off" >&2
    fi

    # kcpassword holds the obfuscated password that automatic login uses
    if defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser >/dev/null 2>&1 ||
      [[ -e /etc/kcpassword ]]; then
      echo "warning: automatic login is on" >&2
    fi
  '';
}
