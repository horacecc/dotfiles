```
# Find the current profile's folder at about:support > Profile Folder and copy its path

# Quit Firefox, then run from the dotfiles directory (quote the path: it has spaces)
sh modules/firefox/arkenfox.sh "<profile folder>"

# Start Firefox and search about:config for _user.js.parrot
# "SUCCESS: user-overrides.js" means both files were applied

# Set by hand:
# 1. Settings > Search > set the default search engine (DuckDuckGo, say)
#    Standard Firefox can't set the default search engine from user.js
# 2. Settings > Privacy & Security > History > Manage Exceptions
#    Add each site to stay signed in to after Firefox closes, e.g. https://github.com, and click Allow
#    For a site that signs in through another, such as Google, add the sign-in site too
#    Not Cookies and Site Data's Manage Exceptions: since Firefox 160 it only allows cookies,
#    which are still cleared on close, and turns off Total Cookie Protection for the site (Bug 1767271)

# Extensions, in this order
# 1. uBlock Origin
#    - Filter Lists > Privacy > check AdGuard/uBO - URL Tracking Protection
# 2. Firefox Multi-Account Containers
# 3. Facebook Container

# To update arkenfox:
# 1. Run make installers-latest in the dotfiles directory
#    It finds the newest version, checks that the raw download matches the git tag, and writes it to arkenfox.sh
#    (It updates bootstrap.sh too; to keep the old one, run git restore bootstrap.sh)
# 2. See what the new version changed at https://github.com/arkenfox/user.js/releases
# 3. Quit Firefox and run arkenfox.sh as above
# After changing user-overrides.js, also quit Firefox and run arkenfox.sh
```
