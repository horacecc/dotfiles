```
# 在 about:support > Profile Folder 找到當前 Profile 的資料夾，複製路徑

# 關閉 Firefox，在 dotfiles 目錄執行（路徑有空白，要加引號）
sh modules/firefox/arkenfox.sh "<Profile 資料夾>"

# 啟動 Firefox，在 about:config 搜尋 _user.js.parrot
# 值是 "SUCCESS: user-overrides.js" 代表兩個檔案都套用了

# 手動設定：
# 1. Settings > Search > 調整預設搜尋引擎（建議 DuckDuckGo）
#    一般版 Firefox 無法用 user.js 設定預設搜尋引擎，只能手動調整

# 安裝套件（依序）
# 1. uBlock Origin
#    - Filter Lists > Privacy > 勾選 AdGuard/uBO - URL Tracking Protection
# 2. Firefox Multi-Account Containers
# 3. Facebook Container

# 之後每次更新 arkenfox 時的流程：
# 1. 在 https://github.com/arkenfox/user.js/tags 找新版本，看它改了哪些設定
# 2. 計算新版本的 hash：
#    curl -fsSL https://raw.githubusercontent.com/arkenfox/user.js/<版本>/user.js | shasum -a 256
# 3. 修改 arkenfox.sh 的 ARKENFOX_VERSION 和 ARKENFOX_SHA256
# 4. 關閉 Firefox，執行上面的 arkenfox.sh
# 修改 user-overrides.js 之後，也是關閉 Firefox 再執行 arkenfox.sh
```
