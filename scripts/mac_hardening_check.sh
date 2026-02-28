#!/bin/bash

# macOS Hardening Check Script
# 檢查 macOS 系統的安全加固狀況
# 用法: chmod +x mac_hardening_check.sh && ./mac_hardening_check.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

pass=0
fail=0
warn=0

ok()   { echo -e "  ${GREEN}[OK]${NC}   $1"; ((pass++)); }
bad()  { echo -e "  ${RED}[FAIL]${NC} $1"; ((fail++)); }
info() { echo -e "  ${YELLOW}[WARN]${NC} $1"; ((warn++)); }

divider() {
    echo -e "${BOLD}${CYAN}==> $1${NC}"
}

echo ""
echo -e "${BOLD}macOS Hardening Check${NC}"
echo -e "Date: $(date)"
echo -e "Host: $(hostname)"
echo -e "User: $(whoami)"
echo -e "macOS: $(sw_vers -productVersion) ($(sw_vers -buildVersion))"
echo -e "Chip: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Apple Silicon")"
echo ""

# ============================================================
divider "磁碟加密 (FileVault)"
# ============================================================

fv_status=$(fdesetup status 2>/dev/null)
if echo "$fv_status" | grep -q "On"; then
    ok "FileVault 已啟用"
else
    bad "FileVault 未啟用 — System Settings > Privacy & Security > FileVault"
fi

# ============================================================
divider "系統完整性保護 (SIP)"
# ============================================================

sip_status=$(csrutil status 2>/dev/null)
if echo "$sip_status" | grep -q "enabled"; then
    ok "SIP 已啟用"
else
    bad "SIP 未啟用 — 這是非常重要的保護，不應關閉"
fi

# ============================================================
divider "防火牆"
# ============================================================

fw_status=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null)
fw_state=$(echo "$fw_status" | grep -oE 'State = [0-9]+' | awk '{print $3}')
if [ "$fw_state" = "1" ]; then
    ok "防火牆已啟用"
elif [ "$fw_state" = "2" ]; then
    ok "防火牆已啟用（阻擋所有非必要連入連線）"
else
    bad "防火牆未啟用 — System Settings > Network > Firewall"
fi

fw_stealth=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode 2>/dev/null)
if echo "$fw_stealth" | grep -qi "on\|enabled"; then
    ok "隱身模式已啟用（不回應 ping 和 port scan）"
else
    info "隱身模式未啟用 — Firewall > Options > Enable Stealth Mode"
fi

fw_blockall=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getblockall 2>/dev/null)
if echo "$fw_blockall" | grep -q "DISABLED"; then
    info "未阻擋所有連入連線 — 如果你不需要任何共享服務，建議開啟"
else
    ok "已阻擋所有連入連線"
fi

fw_signed_output=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getallowsigned 2>/dev/null)

if echo "$fw_signed_output" | grep -q "built-in.*ENABLED"; then
    info "自動允許已簽章的內建軟體接收連入 — 預設開啟，可接受"
else
    ok "已簽章的內建軟體不會自動放行連入"
fi

if echo "$fw_signed_output" | grep -q "downloaded.*ENABLED"; then
    info "自動允許已簽章的下載軟體接收連入 — 建議關閉，手動逐個授權"
else
    ok "已簽章的下載軟體不會自動放行連入"
fi

# ============================================================
divider "Gatekeeper"
# ============================================================

gk_status=$(spctl --status 2>/dev/null)
if echo "$gk_status" | grep -q "enabled"; then
    ok "Gatekeeper 已啟用"
else
    bad "Gatekeeper 未啟用"
fi

# ============================================================
divider "自動更新"
# ============================================================

auto_download=$(defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload 2>/dev/null)
if [ "$auto_download" = "1" ]; then
    ok "自動下載更新已啟用"
else
    info "自動下載更新未啟用"
fi

auto_install=$(defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates 2>/dev/null)
if [ "$auto_install" = "1" ]; then
    ok "自動安裝 macOS 更新已啟用"
else
    info "自動安裝 macOS 更新未啟用 — 你可能偏好手動控制更新"
fi

critical_update=$(defaults read /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall 2>/dev/null)
if [ "$critical_update" = "1" ]; then
    ok "安全性回應和系統檔案自動安裝已啟用"
else
    bad "安全性回應自動安裝未啟用 — 這應該要開"
fi

config_data=$(defaults read /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall 2>/dev/null)
if [ "$config_data" = "1" ]; then
    ok "系統資料檔案和安全性更新自動安裝已啟用"
else
    bad "系統資料檔案自動安裝未啟用 — 這應該要開"
fi

# ============================================================
divider "共享服務"
# ============================================================

if sudo launchctl list 2>/dev/null | grep -q "com.apple.screensharing"; then
    bad "螢幕共享已啟用 — 如不需要請關閉"
else
    ok "螢幕共享已停用"
fi

ssh_status=$(systemsetup -getremotelogin 2>/dev/null)
if echo "$ssh_status" | grep -qi "on"; then
    info "遠端登入 (SSH) 已啟用 — 確認這是你需要的"
else
    ok "遠端登入 (SSH) 已停用"
fi

if sudo launchctl list 2>/dev/null | grep -q "com.apple.smbd"; then
    bad "檔案共享 (SMB) 已啟用 — 如不需要請關閉"
else
    ok "檔案共享 (SMB) 已停用"
fi

airplay_status=$(defaults -currentHost read com.apple.controlcenter AirplayReceiverEnabled 2>/dev/null)
if [ "$airplay_status" = "0" ]; then
    ok "AirPlay Receiver 已停用"
elif [ "$airplay_status" = "1" ]; then
    info "AirPlay Receiver 已啟用 — System Settings > General > AirDrop & Handoff"
else
    info "無法確認 AirPlay Receiver 狀態 — 手動確認 System Settings > General > AirDrop & Handoff"
fi

# ============================================================
divider "使用者帳號"
# ============================================================

guest_account=$(defaults read /Library/Preferences/com.apple.loginwindow GuestEnabled 2>/dev/null)
if [ "$guest_account" = "0" ] || [ -z "$guest_account" ]; then
    ok "訪客帳號已停用"
else
    bad "訪客帳號已啟用 — System Settings > Users & Groups > Guest User"
fi

auto_login=$(defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser 2>/dev/null)
if [ -z "$auto_login" ]; then
    ok "自動登入已停用"
else
    bad "自動登入已啟用，使用者: $auto_login — 這是嚴重的安全風險"
fi

# ============================================================
divider "螢幕鎖定"
# ============================================================

screen_saver_delay=$(sysadminctl -screenLock status 2>&1)
if echo "$screen_saver_delay" | grep -q "immediate"; then
    ok "螢幕鎖定後立即要求密碼"
elif echo "$screen_saver_delay" | grep -q "screenLock is on"; then
    ok "螢幕鎖定已啟用"
else
    info "無法確認螢幕鎖定設定 — 確認 System Settings > Lock Screen"
fi

# ============================================================
divider "網路安全"
# ============================================================

# 檢查監聽中的 port
known_listeners="launchd|symptomsd|mDNSResponder|configd|controlce"
listening=$(lsof -iTCP -sTCP:LISTEN -nP 2>/dev/null | grep -v "^COMMAND" | awk '{print $1, $9}' | sort -u)
unknown_listeners=$(echo "$listening" | grep -vE "$known_listeners")

if [ -n "$unknown_listeners" ]; then
    info "以下非系統程式正在監聽連入連線："
    echo "$unknown_listeners" | while read -r line; do
        echo -e "         $line"
    done
elif [ -n "$listening" ]; then
    ok "只有系統程式在監聽連入連線（launchd, symptomsd 等）"
else
    ok "沒有程式在監聽連入連線"
fi

# 檢查 Wi-Fi 自動加入
wifi_interface=$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{getline; print $2}')
if [ -n "$wifi_interface" ]; then
    auto_join=$(networksetup -getairportnetwork "$wifi_interface" 2>/dev/null)
    ok "Wi-Fi 介面: $wifi_interface"
fi

# ============================================================
divider "隱私設定"
# ============================================================

# 診斷與使用資料
diag_submit=$(defaults read /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist AutoSubmit 2>/dev/null)
if [ "$diag_submit" = "0" ]; then
    ok "診斷資料自動提交已停用"
else
    info "診斷資料可能自動提交給 Apple — System Settings > Privacy & Security > Analytics"
fi

# Siri
siri_enabled=$(defaults read com.apple.assistant.support "Assistant Enabled" 2>/dev/null)
if [ "$siri_enabled" = "0" ] || [ -z "$siri_enabled" ]; then
    ok "Siri 已停用"
else
    info "Siri 已啟用 — 語音資料可能被傳送到 Apple"
fi

# ============================================================
divider "終端機安全"
# ============================================================

# 檢查 Terminal 安全鍵盤輸入
terminal_secure=$(defaults read com.apple.Terminal SecureKeyboardEntry 2>/dev/null)
if [ "$terminal_secure" = "1" ]; then
    ok "Terminal 安全鍵盤輸入已啟用"
else
    info "Terminal 安全鍵盤輸入未啟用 — Terminal > Menu > Secure Keyboard Entry"
fi

# ============================================================
divider "應用程式安全"
# ============================================================

# 檢查 Safari 自動開啟下載
safari_auto_open=$(defaults read com.apple.Safari AutoOpenSafeDownloads 2>/dev/null)
if [ "$safari_auto_open" = "0" ]; then
    ok "Safari 不會自動開啟下載的檔案"
elif [ -z "$safari_auto_open" ]; then
    ok "Safari 未偵測到設定（你可能沒在用 Safari）"
else
    info "Safari 自動開啟下載已啟用 — Safari > Settings > General"
fi

# ============================================================
divider "你的安全工具"
# ============================================================

# 檢查 LuLu
if [ -d "/Applications/LuLu.app" ] || [ -d "$HOME/Applications/LuLu.app" ]; then
    ok "LuLu（outbound 防火牆）已安裝"
else
    info "未偵測到 LuLu"
fi

# 檢查 Mullvad VPN
if [ -d "/Applications/Mullvad VPN.app" ]; then
    ok "Mullvad VPN 已安裝"
    mullvad_running=$(pgrep -x "mullvad-daemon" 2>/dev/null)
    if [ -n "$mullvad_running" ]; then
        ok "Mullvad VPN daemon 正在執行"
    else
        info "Mullvad VPN daemon 未在執行"
    fi
else
    info "未偵測到 Mullvad VPN"
fi

# 檢查 Firefox
if [ -d "/Applications/Firefox.app" ]; then
    ok "Firefox 已安裝"
else
    info "未偵測到 Firefox"
fi

# 檢查 Mullvad Browser
if [ -d "/Applications/Mullvad Browser.app" ]; then
    ok "Mullvad Browser 已安裝"
else
    info "未偵測到 Mullvad Browser"
fi

# 檢查 KeePass 相關
if [ -d "/Applications/KeePassXC.app" ] || [ -d "$HOME/Applications/KeePassXC.app" ]; then
    ok "KeePassXC 已安裝"
else
    info "未偵測到 KeePassXC"
fi

# ============================================================
divider "結果摘要"
# ============================================================

total=$((pass + fail + warn))
echo -e "  ${GREEN}通過: $pass${NC}"
echo -e "  ${RED}失敗: $fail${NC}"
echo -e "  ${YELLOW}警告: $warn${NC}"
echo -e "  總計: $total 項檢查"
echo ""

if [ "$fail" -eq 0 ]; then
    echo -e "  ${GREEN}${BOLD}系統加固狀況良好${NC}"
else
    echo -e "  ${RED}${BOLD}有 $fail 項需要修正${NC}"
fi
echo ""
