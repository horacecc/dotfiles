```
# 在 about:support > Profile Folder 找到當前 Profile 的 Root 資料夾，前往該目錄

# 複製 user-overrides.js 到 Profile
cp $XDG_CONFIG_HOME/firefox/user-overrides.js .

# 從 arkenfox 下載 updater.sh
curl -O https://raw.githubusercontent.com/arkenfox/user.js/master/updater.sh \
     -O https://raw.githubusercontent.com/arkenfox/user.js/master/prefsCleaner.sh

chmod +x updater.sh prefsCleaner.sh

# 執行 updater.sh，選擇 Y
./updater.sh -d

# 重啟 Firefox，讓 user.js 設定生效

# 手動設定：
# 1. Settings > Search > 調整預設搜尋引擎（建議 DuckDuckGo，有在 user-overrifes.js 中設定，但是不知什麼原因會被無視規則）

# 安裝套件（依序）
# 1. uBlock Origin
#    - Filter Lists > Privacy > 勾選 AdGuard/uBO - URL Tracking Protection
# 2. Firefox Multi-Account Containers
# 3. Facebook Container

# 之後每次更新 arkenfox 時的流程：
# 1. 關閉 Firefox
# 2. ./updater.sh -d（選 Y）
# 3. ./prefsCleaner.sh -d -s
# 4. 啟動 Firefox
```
