# dotfiles

個人用dotfilesリポジトリ。Windows 11 / Linux (Debian) の両環境で動作する設定ファイル群です。

**設計方針**: Nushell / WezTerm / Starship を共通レイヤーとし、OSごとの設定分岐を最小限に抑える。

## クイックスタート

### Windows

```powershell
# 1. dotfiles をクローン
git clone https://github.com/warasugitewara/dotfiles $HOME\.config

# 2. Nushell / WezTerm / Starship をインストール（Scoopを使用）
scoop install nushell wezterm starship
```

### Linux (Debian/Ubuntu)

```bash
# 1. dotfiles をクローン
git clone https://github.com/warasugitewara/dotfiles ~/.config

# 2. Homebrew + Brewfile からパッケージをインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
cd ~/.config/linux && brew bundle install

# 3. シェルを再起動
exec bash
```

## ディレクトリ構成

```
.config/
├── nushell/            # Nushell 設定 (Windows / Linux 共通)
├── nvim/               # Neovim 設定 (LazyVim ベース, 共通)
├── wezterm/            # WezTerm 設定 (共通)
├── starship.toml       # Starship プロンプト設定 (共通)
├── git/                # Git グローバル設定 (共通)
├── keymap/             # キーボードキーマップ (Mint60, A75)
├── powershell/         # PowerShell 設定 (Windows 専用)
├── scoop/              # Scoop パッケージマネージャー設定 (Windows 専用)
├── docker/             # Docker 設定 (共通)
├── python/             # Python 設定 (共通)
├── ruby/               # Ruby 設定 (共通)
├── npm/                # npm 設定 (共通)
├── go/                 # Go 設定 (共通)
├── pip/                # pip 設定 (共通)
└── linux/              # Linux 専用
    ├── Brewfile        # Homebrew パッケージリスト
    ├── bashrc.xdg-config  # XDG 統合用 bashrc セクション
    ├── SETUP.md        # Linux 環境構築ガイド
    └── zellij/         # Zellij ターミナルマルチプレクサ設定
```

## 主な設定

### Nushell (`nushell/`)

| ファイル | 説明 |
|---------|------|
| `config.nu` | メイン設定。XDG変数、カスタムコマンド (`llm`, `ai`, `fcc`, `fuck`) |
| `env.nu` | 環境変数・エイリアス。calcpp統合、Headroom Proxyアドレス |

**カスタムコマンド:**

| コマンド | 説明 |
|---------|------|
| `llm [prompt]` | deepseek-r1:8b via Ollama を起動 |
| `ai` | Aider + llm-router 経由で起動（オンライン: Claude Sonnet、オフライン: deepseek-r1:8b） |
| `fcc [...args]` | Claude Code を Nvidia NIM プロキシ経由で起動 |
| `fuck` | thefuck 統合 |
| `calc [expr]` | calcpp CLI 電卓 (Windows) |

### Neovim (`nvim/`)

LazyVim ベース。主なプラグイン:

| プラグイン | 説明 |
|-----------|------|
| `telescope.lua` | ファジーファインダー |
| `oil.lua` | ファイラー |
| `copilot.lua` | GitHub Copilot |
| `cord.lua` | Discord Rich Presence |
| `markview.lua` | Markdown プレビュー |
| `nvim-java.lua` | Java LSP |
| `tokyonight.lua` | カラーテーマ |

### WezTerm (`wezterm/`)

| ファイル | 説明 |
|---------|------|
| `wezterm.lua` | フォント (HackGen Console NF)、カラー、タブ設定 |
| `keybinds.lua` | vim スタイルのキーバインド (Ctrl-Q リーダー) |

### PowerShell (`powershell/`) — Windows 専用

| ファイル | 説明 |
|---------|------|
| `Microsoft.PowerShell_profile.ps1` | プロファイル設定 |
| `powershell.config.json` | PowerShell 設定 |

## XDG Base Directory 対応

すべての設定は XDG Base Directory Specification に準拠:

```
XDG_CONFIG_HOME = ~/.config      (設定ファイル)
XDG_DATA_HOME   = ~/.local/share (データファイル)
XDG_CACHE_HOME  = ~/.cache       (キャッシュ)
```

| ツール | 設定ファイル | 環境変数 |
|-------|------------|---------|
| Python | `python/pythonrc.py`, `pip/pip.conf` | `PYTHONSTARTUP` |
| Ruby | `ruby/irbrc`, `ruby/gemrc` | `IRBRC`, `GEM_HOME` |
| npm | `npm/npmrc` | `npm_config_userconfig` |
| Go | `go/env` | `GOPATH`, `GOMODCACHE` |
| Git | `git/config` | `GIT_CONFIG_GLOBAL` |
| Docker | `docker/config.json` | `DOCKER_CONFIG` |

### Linux での XDG 統合有効化

```bash
cat ~/.config/linux/bashrc.xdg-config >> ~/.bashrc
source ~/.bashrc
```

## 環境

| 項目 | 内容 |
|-----|------|
| OS | Windows 11 / Linux (Debian) |
| シェル | Nushell (共通), pwsh7,bash |
| エディタ | Neovim (LazyVim) |
| ターミナル | WezTerm |
| プロンプト | Starship |
| マルチプレクサ | Zellij (一部のLinuxのみ) |

## Git グローバル設定

クローン後、メールアドレスをローカルで設定:

```bash
git config --global user.email "your@email.com"
```

## ライセンス

MIT
