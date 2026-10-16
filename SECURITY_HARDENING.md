# 安全與隱私補強計畫

這份文件是對 horacecc/dotfiles 做安全與隱私檢查後，留下來要實作的項目。
檢查日期 2026-10-16。工作樹與 git 歷史都沒有憑證、token 或私人資料外洩，
以下是尚未設定或可再加強的部分。

## Repo 慣例（實作前先讀）

- macOS 設定每個主題一個檔案，放在 `modules/macos/`，並在 `modules/macos/default.nix` 的 `imports` 登錄。
- `system.defaults` 寫不到的設定（ByHost、不在 defaults 裡的），用 `system.activationScripts.postActivation.text`。
  啟動腳本以 root 執行，屬於使用者的設定要透過 `launchctl asuser ... sudo --user=${currentSystemUser} --` 執行，
  範例見 `modules/macos/continuity.nix` 與 `modules/macos/lock-screen.nix`。
- 在 VM 裡無法驗證的設定，註解開頭標 `Unverified:` 並說明原因。可用 `git grep Unverified` 找到既有寫法。
- 要找偏好設定的 key，用 `make diffmacos`：先跑一次，在 System Settings 改設定，再跑一次看差異。
  ByHost 設定另外比對 `defaults -currentHost read`。
- 每個設定值旁邊若是魔術數字，加一行註解說明意義（例如 `# 4 is UTF-8`）。
- 私密內容不進 repo。需要使用者自己填的東西放 `templates/`，README 的「Private files」表格要同步更新，
  並說明要「複製」而不是「連結」。
- 新增 Homebrew 套件寫在 `homebrew.brews` / `homebrew.casks`，不要用 `brew install`。
- 改完跑 `nix fmt`。flake 只看得到 git 追蹤的檔案，新檔案要先 `git add`（或 `git add -N`）才能 build。
- 本機驗證：`nix build .#darwinConfigurations.mac.system`，再 `make nix-switch`。

## 已決定不做的項目（不要再提）

- 全域 gitignore 不加 `.env.*`、`*.pem`、`*.key`：有些專案需要 commit 這些檔案。
- Firefox 不改 `network.trr.mode`：平常開著 Mullvad VPN，DNS 已由 VPN 保護。
- 不更換 commit email，也不調整 `machines/mac.nix` 的應用程式清單。

## 1. macOS 隱私遙測與建議功能（高優先）

目前 `modules/macos/` 沒有任何關於 Apple 個人化廣告、Siri、Siri 建議、診斷資料分享的設定。

**做法**：新增 `modules/macos/privacy.nix`，登錄到 `default.nix`。起始內容：

```nix
{
  system.defaults = {
    CustomUserPreferences = {
      # System Settings > Privacy & Security > Apple Advertising
      "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
      "com.apple.AdLib".allowIdentifierForAdvertising = false;

      # Unverified: the VM has no Siri; turns Siri off and hides its menu bar icon
      "com.apple.assistant.support"."Assistant Enabled" = false;
      "com.apple.Siri".StatusMenuVisible = false;
      "com.apple.Siri".VoiceTriggerUserEnabled = false;

      # Siri Suggestions in Look Up
      "com.apple.lookup.shared".LookupSuggestionsDisabled = true;
    };

    # System Settings > Privacy & Security > Analytics & Improvements
    # Unverified: the file may be protected; check that the switch wrote it
    CustomSystemPreferences."/Library/Application Support/CrashReporter/DiagnosticMessagesHistory" = {
      AutoSubmit = false;
      ThirdPartyDataSubmit = false;
    };
  };
}
```

**還要查的 key**（用 `make diffmacos` 確認，再補進同一個檔案）：

- Privacy & Security > Analytics & Improvements 裡的「Improve Siri & Dictation」與「Share iCloud Analytics」。
- Spotlight 的 Siri Suggestions / 「Help Apple Improve Search」。這個 key 不穩定，`diffmacos` 看不到就寫進 README 的 Manual steps。
- Safari 的 `UniversalSearchEnabled = false` 與 `SuppressSearchSuggestions = true`：Safari 的偏好設定在 sandbox container 內，
  `defaults write com.apple.Safari` 需要終端機有 Full Disk Access。若寫不進去，改列為 Manual steps。

**驗證**：switch 後登出登入，到 System Settings 對應頁面確認開關狀態。

## 2. Homebrew 分析回報（高優先）

Homebrew 的匿名分析是預設開啟、需要手動關閉。`modules/fish/env.fish` 目前沒有關。

**做法**：

1. 在 `modules/fish/env.fish` 的 `if test -d /opt/homebrew` 區塊內加入：

   ```fish
   set -gx HOMEBREW_NO_ANALYTICS 1
   set -gx HOMEBREW_NO_INSECURE_REDIRECT 1
   ```

2. 在 `machines/darwin-shared.nix` 加 `environment.variables.HOMEBREW_NO_ANALYTICS = "1";`，讓非 fish 的 shell 也生效。

3. switch 期間 nix-darwin 會以使用者身分跑 `brew bundle`，不一定吃得到上面的環境變數。
   `brew analytics off` 會把設定寫進 Homebrew 自己的 git config，之後所有 brew 指令都生效。
   在 `darwin-shared.nix`（或新的 `modules/homebrew/default.nix`）的 `postActivation` 加入，
   比照 `lock-screen.nix` 的「先查狀態、不符才改」寫法：

   ```bash
   brew=/opt/homebrew/bin/brew
   if [ -x "$brew" ] && [[ $(${asUser} "$brew" analytics state 2>/dev/null) != *disabled* ]]; then
     echo "turning Homebrew analytics off..." >&2
     ${asUser} "$brew" analytics off
   fi
   ```

**驗證**：`brew analytics state` 應輸出 `Analytics are disabled.`。

## 3. Nix 建置沙箱（中優先）

nix-darwin 在 macOS 上預設不開沙箱，建置腳本以 nixbld 使用者跑在無隔離的環境。Nix 2.34 的 Darwin 沙箱已可用。

**做法**：在 `machines/darwin-shared.nix` 的 `nix.settings` 加：

```nix
nix.settings.sandbox = true;
# Fail instead of silently building without a sandbox
nix.settings.sandbox-fallback = false;
```

**驗證**：switch 後 `nix config show | grep sandbox` 應為 `sandbox = true`，並重新 build 一次系統確認沒有套件因沙箱失敗。
若有個別套件失敗，先退到 `sandbox = "relaxed"` 並在註解寫下是哪個套件，再視情況回報上游。

## 4. git 提交簽章（中優先）

`templates/.gitconfig.user` 只有註解掉的 `gpgsign`。既然已經用 1Password，用它的 SSH agent 簽章最省事，
而且不需要 gnupg 的金鑰管理。

**做法**：更新 `templates/.gitconfig.user`，保留佔位符，不放真實值：

```ini
#[user]
#	email = <email>
#	name = <username>
#	# The public key, as 1Password shows it in the SSH key item
#	signingkey = ssh-ed25519 AAAA...

#[gpg]
#	format = ssh

#[gpg "ssh"]
#	program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign
#	# Lets git log --show-signature verify your own commits locally
#	allowedSignersFile = ~/.ssh/allowed_signers

#[commit]
#	gpgsign = true

#[tag]
#	gpgsign = true

#[includeIf "gitdir:~/<path>/"]
#	path = ~/.gitconfig.<customization>
```

另外在 `templates/` 加 `allowed_signers` 範本（格式：`<email> ssh-ed25519 AAAA...`），
並把兩者加進 README 的 Private files 表格（複製到 `~/.gitconfig.user`、`~/.ssh/allowed_signers`）。

**前置條件**：1Password > Settings > Developer 開啟 SSH Agent，並把簽章用的 SSH 金鑰存在 1Password。
GitHub 端要把同一把公鑰加為 Signing Key，commit 才會顯示 Verified。

**驗證**：`git commit --allow-empty -m test` 後 `git log --show-signature -1` 顯示 Good signature。

## 5. SSH 用戶端設定模組（中優先）

repo 沒有管理 `~/.ssh/config`。缺少 `IdentitiesOnly` 時 ssh 會把 agent 裡所有公鑰逐一送給伺服器，
`known_hosts` 不雜湊則會洩漏連過的主機清單。

**做法**：新增 `modules/ssh/default.nix`，在 `machines/mac.nix` 與 `machines/utm.nix` 的 `imports` 加入：

```nix
{
  home-manager.sharedModules = [
    {
      programs.ssh = {
        enable = true;
        # home-manager's default block is being removed; set everything in "*" ourselves
        enableDefaultConfig = false;
        matchBlocks."*" = {
          # Only offer the key named for the host, not every key the agent holds
          identitiesOnly = true;
          hashKnownHosts = true;
          extraOptions = {
            # Accept host key rotations announced by servers we already trust
            UpdateHostKeys = "yes";
            # 1Password's SSH agent; needs Settings > Developer > SSH Agent turned on
            IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
          };
        };
      };
    }
  ];
}
```

**注意**：

- home-manager 26.05 的 `programs.ssh` 選項名稱請以 `man home-configuration.nix` 為準；
  舊版頂層的 `hashKnownHosts` 等選項已改到 `matchBlocks."*"` 底下。
- 既有的 `~/.ssh/config` 會被改名為 `config.before-home-manager`，switch 後要把裡面的個別 Host 區塊搬回來。
  個別主機的設定若含私人主機名稱，放 `~/.ssh/config.d/` 之類的檔案並用 `Include` 引入，不要進 repo。
- 連 GitHub 時要在 1Password 裡設定該金鑰，或在 Host 區塊指定 `IdentityFile` 為公鑰路徑，`IdentitiesOnly` 才找得到。

**驗證**：`ssh -T git@github.com` 成功；`ssh -G github.com | grep -i -E 'identitiesonly|hashknownhosts|identityagent'`。

## 6. 啟動期完整性警告與登入防護（中優先）

`modules/macos/filevault.nix` 與 `sharing.nix` 的「只警告、不改」模式很好，可以擴充到 Gatekeeper、SIP、自動登入。
另外加 sudo 的 Touch ID 與停用登入畫面的 console 模式。

**做法**：新增 `modules/macos/integrity.nix`，登錄到 `default.nix`：

```nix
{
  # Touch ID for sudo, so the password is typed in the terminal less often;
  # reattach makes it work inside tmux
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  # Typing ">console" at the login window would give a text login
  system.defaults.loginwindow.DisableConsoleAccess = true;

  # Turning these on or off needs Recovery or a password, so a switch only warns
  system.activationScripts.postActivation.text = ''
    if [[ $(spctl --status 2>&1) != *"assessments enabled"* ]]; then
      echo "warning: Gatekeeper is off" >&2
    fi

    if [[ $(csrutil status 2>&1) != *"enabled."* ]]; then
      echo "warning: System Integrity Protection is off" >&2
    fi

    if defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser >/dev/null 2>&1 ||
      [[ -e /etc/kcpassword ]]; then
      echo "warning: automatic login is on" >&2
    fi
  '';
}
```

**注意**：

- `security.pam.services.sudo_local.*` 是 nix-darwin 25.05 之後的選項名稱；舊名 `security.pam.enableSudoTouchIdAuth` 已淘汰。
- 在 UTM VM 裡沒有 Touch ID，選項本身無害，但驗證要在實機。
- `csrutil status` 在 VM 可能輸出不同文字，必要時標 `Unverified`。

**驗證**：switch 時沒有 warning；`sudo -k && sudo true` 跳出 Touch ID 提示。

## 9. 自動化檢查（低優先）

repo 沒有 `.github/`，`make installers-check` 只能靠手動記得跑。

**做法**：

1. 新增 `.github/workflows/check.yml`，在 Apple Silicon runner（`macos-15` 或更新）上跑：
   - `shellcheck bootstrap.sh scripts/check-installers.sh modules/firefox/arkenfox.sh modules/op/op modules/git/gitignore`
     （後兩個沒有 shebang，用 `shellcheck -s sh`）。
   - `nix fmt -- --ci`（nixfmt-tree 是 treefmt，`--ci` 會在有差異時失敗）。
   - `nix eval --raw .#darwinConfigurations.mac.system.drvPath` 與 `utm`，確認設定可以求值，不必真的 build。
   - `make installers-check`：排程每週跑一次（`schedule: cron`），push 時也跑。失敗代表上游安裝腳本或 pkg 變了。
2. 安裝 Nix 用 `DeterminateSystems/nix-installer-action` 或 `cachix/install-nix-action`，所有第三方 action 釘住 commit SHA，不要用 tag。
3. 加 `.github/dependabot.yml` 更新 GitHub Actions 的版本。flake 更新可選 `DeterminateSystems/update-flake-lock` 開 PR。
4. GitHub repo Settings > Code security：開啟 Secret scanning 與 Push protection（公開 repo 免費）。這一步在網頁做，不在 repo 內。

**驗證**：在分支上推一個故意改壞 `bootstrap.sh` hash 的 commit，確認 workflow 變紅。

## 11. Ghostty 捲動緩衝（低優先）

`modules/ghostty/config` 的 `scrollback-limit = 100000000` 是每個分頁 100 MB，
且 `cmd+shift+s` 綁 `write_scrollback_file:open`，會把整份 scrollback 寫到暫存檔再用 open 打開。

**選項**（擇一，或維持現狀並加註解說明是刻意的）：

- 把 `scrollback-limit` 降到 `10000000`（10 MB），減少敏感輸出留在記憶體與暫存檔的量。
- 把 `write_scrollback_file:open` 改成 `write_scrollback_file:paste`，只把暫存檔路徑貼到命令列，不自動用其他 app 開啟。
- 保留功能，但在 config 加註解提醒暫存檔位置由 Ghostty 決定，用完要刪。
