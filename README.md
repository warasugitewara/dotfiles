![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)<!-- markdownlint-disable-line -->

# Dotfiles

```text
     _       _    __ _ _
  __| | ___ | |_ / _(_) | ___  ___
 / _` |/ _ \| __| |_| | |/ _ \/ __|
| (_| | (_) | |_|  _| | |  __/\__ \
 \__,_|\___/ \__|_| |_|_|\___||___/   Windows 11 / Linux
```

<!-- スクショ/GIF は後日追加予定: <img src="images/preview.png" alt="preview" width="850"/> -->

![Platform](https://img.shields.io/badge/platform-Windows%2011%20%7C%20Linux-1f6feb?style=flat-square)
![Shell](https://img.shields.io/badge/shell-Nushell-4e9a06?style=flat-square)
![Editor](https://img.shields.io/badge/editor-Neovim-57A143?style=flat-square&logo=neovim&logoColor=white)
![Terminal](https://img.shields.io/badge/terminal-WezTerm-4E49EE?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)
![Last commit](https://img.shields.io/github/last-commit/warasugitewara/dotfiles?style=flat-square)

> **Windows 11 / Linux (Debian) 両対応**のクロスプラットフォーム dotfiles。
> Nushell・WezTerm・Starship を共通レイヤーに据え、OS ごとの設定分岐を最小限に抑えています。

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## ✨ Highlights

- 🌐 **クロスプラットフォーム** — Nushell / WezTerm / Starship を共通レイヤーにし、Windows と Linux で同じ設定を使い回す
- 🗂️ **XDG 準拠** — 散らかりがちなツール設定をすべて `~/.config` に集約
- 🤖 **AI 統合** — `llm` (Ollama) / `ai` (Aider) / `fcc` (Claude Code) をシェルコマンド化
- 🔀 **OS 自動分岐** — `btop`→`btop4win`、`nano`→`nvim` を OS ごとに透過切り替え
- 💾 **災害復旧** — `scoop import` / `winget import` でパッケージ一括復元、`nvim/lazy-lock.json` でプラグイン固定

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🛠️ Tools

| 種別 | ツール | 対象 |
| --- | --- | --- |
| **terminal** | [WezTerm](https://wezfurlong.org/wezterm/) | 共通 |
| **shell** | [Nushell](https://www.nushell.sh/) | 共通 |
| **editor** | [Neovim](https://neovim.io/) ([LazyVim](https://www.lazyvim.org/)) | 共通 |
| **prompt** | [Starship](https://starship.rs/) | 共通 |
| **multiplexer** | [Zellij](https://zellij.dev/) | 一部Linux |

### Settings

| 対象 | ツール | 場所 |
| --- | --- | --- |
| **共通** | WezTerm | [`wezterm/`](https://github.com/warasugitewara/dotfiles/tree/main/wezterm) |
| | Nushell | [`nushell/`](https://github.com/warasugitewara/dotfiles/tree/main/nushell) |
| | Neovim | [`nvim/`](https://github.com/warasugitewara/dotfiles/tree/main/nvim) |
| | Starship | [`starship.toml`](https://github.com/warasugitewara/dotfiles/blob/main/starship.toml) |
| | Git | [`git/`](https://github.com/warasugitewara/dotfiles/tree/main/git) |
| **Windows** | PowerShell 7 | [`powershell/`](https://github.com/warasugitewara/dotfiles/tree/main/powershell) |
| | Scoop | [`scoop/`](https://github.com/warasugitewara/dotfiles/tree/main/scoop) |
| | 復元マニフェスト | [`windows/`](https://github.com/warasugitewara/dotfiles/tree/main/windows) |
| **Linux** | Zellij / Brewfile 等 | [`linux/`](https://github.com/warasugitewara/dotfiles/tree/main/linux) |
| **その他** | キーマップ | [`keymap/`](https://github.com/warasugitewara/dotfiles/tree/main/keymap) |

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🚀 Setup

### 🪟 Windows

```powershell
# 1. dotfiles をクローン
git clone https://github.com/warasugitewara/dotfiles $HOME\.config

# 2. パッケージを一括復元（災害復旧）
#    Scoop 未導入なら先に: irm get.scoop.sh | iex
scoop import $HOME\.config\windows\scoop.json
winget import -i $HOME\.config\windows\winget.json --accept-package-agreements --accept-source-agreements

# 3. PowerShell プロファイルを配置 (任意)
#    $PROFILE が powershell/Microsoft.PowerShell_profile.ps1 を読むよう設定
```

### 🐧 Linux (Debian / Ubuntu)

```bash
# 1. dotfiles をクローン
git clone https://github.com/warasugitewara/dotfiles ~/.config

# 2. Homebrew + Brewfile からパッケージをインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
cd ~/.config/linux && brew bundle install

# 3. XDG 統合を bashrc に追記
cat ~/.config/linux/bashrc.xdg-config >> ~/.bashrc && source ~/.bashrc
```

> [!NOTE]
> 詳細な Linux 環境構築手順は [`linux/SETUP.md`](https://github.com/warasugitewara/dotfiles/blob/main/linux/SETUP.md) を参照。

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 📦 パッケージ復元 (Windows)

`windows/` に導入済みパッケージのマニフェストを保持。ディスク故障・災害時に**一括再導入**できる。

| ファイル | 内容 | 復元コマンド |
| --- | --- | --- |
| [`scoop.json`](https://github.com/warasugitewara/dotfiles/blob/main/windows/scoop.json) | scoop 12アプリ（gcc / gradle / jdtls / lua-language-server / ollama / python / JDK 等） | `scoop import windows/scoop.json` |
| [`winget.json`](https://github.com/warasugitewara/dotfiles/blob/main/windows/winget.json) | winget 厳選 34件（下記） | `winget import -i windows/winget.json` |
| [`nushell alias.md`](https://github.com/warasugitewara/dotfiles/blob/main/windows/nushell%20alias.md) | Windows 用 Nushell エイリアスのメモ | — |

<details>
<summary>winget.json の内訳（34件）</summary>

| カテゴリ | パッケージ |
| --- | --- |
| コア | Neovim / Nushell / WezTerm / Starship / PowerShell / WindowsTerminal / WSL / Ubuntu |
| VCS | Git / GitHub CLI / GitHub Desktop / Copilot |
| ランタイム・ビルド | Node.js / Rustup / uv / VS BuildTools / InnoSetup |
| CLI | ripgrep / fastfetch / btop4win / FFmpeg / 7zip / gsudo |
| エディタ | VS Code / Zed / sakura / TeraTerm |
| AI CLI | Claude / Codex |
| インフラ接続 | Twingate / Tailscale |
| ブラウザ・通信 | Chrome / Discord / Vivaldi |

> 更新: `scoop export > windows/scoop.json` / `winget export` 後に開発ツールを厳選して反映。
> ゲーム・メディア・システムランタイム等のノイズは除外している。

</details>

> [!NOTE]
> Linux 側のパッケージは [`linux/Brewfile`](https://github.com/warasugitewara/dotfiles/blob/main/linux/Brewfile)（`brew bundle`）で管理。
> GUI アプリは Homebrew(Linux) が cask 非対応のため対象外。

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 📁 Structure

```text
.config/
├── nushell/        # Nushell      (shell,    共通)  config.nu / env.nu
├── nvim/           # Neovim       (LazyVim,  共通)  lazy-lock.json で固定
├── wezterm/        # WezTerm      (terminal, 共通)  wezterm.lua / keybinds.lua
├── starship.toml   # Starship     (prompt,   共通)
├── git/            # Git          (共通)
├── keymap/         # 自作キーボード (Mint60 / Drunkdeer A75 + チートシート)
├── powershell/     # PowerShell 7 (Windows)  profile.ps1 / config.json
├── scoop/          # Scoop 設定   (Windows)
├── windows/        # Windows 専用
│   ├── scoop.json       # scoop 復元マニフェスト
│   ├── winget.json      # winget 復元マニフェスト
│   └── nushell alias.md # Nushell エイリアスのメモ
├── python/ ruby/ go/ pip/   # 各ツールの XDG 設定 (共通)
├── chrome-addon/   # ブラウザ拡張 (AdGuard ルール等)
├── waras/          # GitHub プロフィール README (warasugitewara/warasugitewara)
└── linux/          # Linux 専用
    ├── Brewfile           # Homebrew パッケージリスト
    ├── bashrc.xdg-config  # XDG 統合 bashrc
    ├── SETUP.md           # 環境構築ガイド
    └── zellij/            # Zellij 設定 (config.kdl)
```

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🧩 Nushell Commands

`nushell/config.nu` / `env.nu` で定義しているカスタムコマンド。

| コマンド | 説明 |
| --- | --- |
| `llm [prompt]` | [deepseek-r1:8b](https://ollama.com/library/deepseek-r1) を Ollama 経由で起動 |
| `ai` | [Aider](https://aider.chat/) + llm-router（オンライン: Claude Sonnet / オフライン: deepseek-r1:8b） |
| `btop` | Windows では `btop4win`、Linux/macOS では native `btop` に自動分岐 |
| `nano` | Windows では `nvim`、Linux/macOS では native `nano` に自動分岐 |
![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🗂️ XDG Base Directory

すべての設定は [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/) に準拠。

```text
XDG_CONFIG_HOME = ~/.config        # 設定ファイル
XDG_DATA_HOME   = ~/.local/share   # データファイル
XDG_CACHE_HOME  = ~/.cache         # キャッシュ
```

<details>
<summary>ツール別の XDG 統合設定</summary>

| ツール | 設定ファイル | 環境変数 |
| --- | --- | --- |
| Python | `python/pythonrc.py`, `pip/pip.conf` | `PYTHONSTARTUP` |
| Ruby | `ruby/irbrc`, `ruby/gemrc` | `IRBRC`, `GEM_HOME` |
| Go | `go/env` | `GOPATH`, `GOMODCACHE` |
| Git | `git/config` | `GIT_CONFIG_GLOBAL` |

> Linux では [`linux/bashrc.xdg-config`](https://github.com/warasugitewara/dotfiles/blob/main/linux/bashrc.xdg-config) を `~/.bashrc` に追記して有効化します。

</details>

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 📝 Notes

> [!IMPORTANT]
> Git のメールアドレスは**リポジトリに含めていません**。クローン後にローカルで設定してください。
>
> ```bash
> git config --global user.email "your@email.com"
> ```

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🙏 Acknowledgements

特に参考にさせていただいた dotfiles リポジトリです。

- [mozumasu/dotfiles](https://github.com/mozumasu/dotfiles) — ターミナル環境（WezTerm など）の構成と見せ方
- [ryoppippi/dotfiles](https://github.com/ryoppippi/dotfiles) — macOS / Linux クロスプラットフォーム構成

## License

[MIT](LICENCE)
