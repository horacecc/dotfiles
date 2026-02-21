```
# 搜尋`about:profiles`，複製並前往當前 Profile 的 Root 資料夾

# 複製 user-overrides.js 到 Profile
cp $XDG_CONFIG_HOME/firefox/user-overrides.js .

# 從 github.com/arkenfox/user.js 下載
curl -O https://raw.githubusercontent.com/arkenfox/user.js/master/updater.sh \
     -O https://raw.githubusercontent.com/arkenfox/user.js/master/prefsCleaner.sh

# 執行 updater.sh，選擇Y
chmod +x updater.sh
./updater.sh -d

# 安裝套件
Facebook Container
Firefox Multi-Account Containers
uBlock Origin
ClearURLs

# 執行 prefsCleaner.sh
chmod +x prefsCleaner.sh
./prefsCleaner.sh -d -s

```
