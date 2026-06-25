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
![Shell](https://img.shields.io/badge/shell-Nushell%20%7C%20PowerShell-4e9a06?style=flat-square)
![Editor](https://img.shields.io/badge/editor-Neovim-57A143?style=flat-square&logo=neovim&logoColor=white)
![Terminal](https://img.shields.io/badge/terminal-WezTerm-4E49EE?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)
![Last commit](https://img.shields.io/github/last-commit/warasugitewara/dotfiles?style=flat-square)

> **Windows 11 / Linux (Debian) 両対応**のクロスプラットフォーム dotfiles。
> Nushell・WezTerm・Starship を共通レイヤーに据え、OS ごとの設定分岐を最小限に抑えています。

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🛠️ Tools

| 種別 | ツール | 対象 |
| --- | --- | --- |
| **terminal** | [WezTerm](https://wezfurlong.org/wezterm/) | 共通 |
| **shell** | [Nushell](https://www.nushell.sh/) | 共通 |
| | [PowerShell 7](https://learn.microsoft.com/powershell/) | Windows |
| **editor** | [Neovim](https://neovim.io/) ([LazyVim](https://www.lazyvim.org/)) | 共通 |
| **prompt** | [Starship](https://starship.rs/) | 共通 |
| **multiplexer** | [Zellij](https://zellij.dev/) | Linux |

### Settings

- WezTerm &nbsp;→&nbsp; [`wezterm/`](https://github.com/warasugitewara/dotfiles/tree/main/wezterm)
- Nushell &nbsp;→&nbsp; [`nushell/`](https://github.com/warasugitewara/dotfiles/tree/main/nushell)
- Neovim &nbsp;→&nbsp; [`nvim/`](https://github.com/warasugitewara/dotfiles/tree/main/nvim)
- PowerShell &nbsp;→&nbsp; [`powershell/`](https://github.com/warasugitewara/dotfiles/tree/main/powershell)
- Starship &nbsp;→&nbsp; [`starship.toml`](https://github.com/warasugitewara/dotfiles/blob/main/starship.toml)
- Linux 専用 &nbsp;→&nbsp; [`linux/`](https://github.com/warasugitewara/dotfiles/tree/main/linux)

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🚀 Setup

### 🪟 Windows

```powershell
# 1. dotfiles をクローン
git clone https://github.com/warasugitewara/dotfiles $HOME\.config

# 2. Nushell / WezTerm / Starship をインストール (Scoop)
scoop install nushell wezterm starship

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

> 詳細な Linux 環境構築手順は [`linux/SETUP.md`](https://github.com/warasugitewara/dotfiles/blob/main/linux/SETUP.md) を参照。

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 📁 Structure

```text
.config/
├── nushell/        # Nushell      (共通)
├── nvim/           # Neovim       (LazyVim, 共通)
├── wezterm/        # WezTerm      (共通)
├── starship.toml   # Starship     (共通)
├── git/            # Git          (共通)
├── powershell/     # PowerShell 7 (Windows)
├── scoop/          # Scoop        (Windows)
├── keymap/         # キーマップ    (Mint60 / A75)
├── docker/ python/ ruby/ npm/ go/ pip/   # 各ツールの XDG 設定
└── linux/          # Linux 専用
    ├── Brewfile           # Homebrew パッケージリスト
    ├── bashrc.xdg-config  # XDG 統合 bashrc
    ├── SETUP.md           # 環境構築ガイド
    └── zellij/            # Zellij 設定
```

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🧩 Nushell Commands

`nushell/config.nu` / `env.nu` で定義しているカスタムコマンド。

| コマンド | 説明 |
| --- | --- |
| `llm [prompt]` | [deepseek-r1:8b](https://ollama.com/library/deepseek-r1) を Ollama 経由で起動 |
| `ai` | [Aider](https://aider.chat/) + llm-router（オンライン: Claude Sonnet / オフライン: deepseek-r1:8b） |
| `fcc [...args]` | Claude Code を Nvidia NIM プロキシ経由で起動 |
| `fuck` | [thefuck](https://github.com/nvbn/thefuck) 統合（直前コマンドを自動修正） |
| `calc [expr]` | calcpp CLI 電卓 *(Windows)* |
| `btop` | Windows では `btop4win`、Linux/macOS では native `btop` に自動分岐 |

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🗂️ XDG Base Directory

すべての設定は [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/) に準拠。

```text
XDG_CONFIG_HOME = ~/.config        # 設定ファイル
XDG_DATA_HOME   = ~/.local/share   # データファイル
XDG_CACHE_HOME  = ~/.cache         # キャッシュ
```

| ツール | 設定ファイル | 環境変数 |
| --- | --- | --- |
| Python | `python/pythonrc.py`, `pip/pip.conf` | `PYTHONSTARTUP` |
| Ruby | `ruby/irbrc`, `ruby/gemrc` | `IRBRC`, `GEM_HOME` |
| npm | `npm/npmrc` | `npm_config_userconfig` |
| Go | `go/env` | `GOPATH`, `GOMODCACHE` |
| Git | `git/config` | `GIT_CONFIG_GLOBAL` |
| Docker | `docker/config.json` | `DOCKER_CONFIG` |

![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 📝 Notes

クローン後、Git のメールアドレスはローカルで設定してください（リポジトリには含めません）。

```bash
git config --global user.email "your@email.com"
```

## License

[MIT](LICENCE)
