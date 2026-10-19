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
# 1. 在 dotfiles 目錄執行 make installers-latest
#    它會找出最新版本，確認 raw 下載和 git tag 的內容相同，再寫回 arkenfox.sh
#    （它也會更新 bootstrap.sh；不想更新的話，用 git restore bootstrap.sh 還原）
# 2. 到 https://github.com/arkenfox/user.js/releases 看新版本改了哪些設定
# 3. 關閉 Firefox，執行上面的 arkenfox.sh
# 修改 user-overrides.js 之後，也是關閉 Firefox 再執行 arkenfox.sh
```
