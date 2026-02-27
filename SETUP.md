# 開発環境構築ガイド

このファイルでは、Debian 13 上での開発環境の詳細な構築方法を説明します。

## インストール済みパッケージ（Debian 13）

### 言語・ランタイム
| 言語 | バージョン | インストール方法 |
|-----|----------|-----------------|
| **Python 3** | 3.14.3 | `brew install python@3.14` |
| **Go** | 1.26.0 | `brew install go` |
| **Ruby** | 4.0.1 | `brew install ruby` |
| **Node.js** | 25.6.1 | `brew install node` |
| **Rust** | 1.93.1 | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| **Java** | GraalVM 25.0.2 | `brew install openjdk@21` |
| **PHP** | 8.5.3 | `brew install php` |

### 開発ツール
| ツール | バージョン | 説明 |
|-------|----------|------|
| **Neovim** | 0.11.6 | エディタ（LazyVim設定） |
| **Git** | 2.47.3 | バージョン管理 |
| **Docker** | 29.2.1 | コンテナ化 |
| **Docker Compose** | 最新 | マルチコンテナ管理 |

### CLI ユーティリティ
| ツール | バージョン | 説明 |
|-------|----------|------|
| **ripgrep (rg)** | 最新 | 高速コード検索 |
| **fd** | 最新 | find の高速代替 |
| **bat** | 最新 | cat の高機能版 |
| **eza** | 0.23.4 | ls の高速代替 (旧 exa) |
| **Starship** | 最新 | プロンプトカスタマイズ |

### パッケージマネージャ
| ツール | 説明 |
|-------|------|
| **Homebrew** | macOS/Linux パッケージマネージャ |
| **npm** | Node.js パッケージマネージャ |
| **pip/venv** | Python パッケージ管理・仮想環境 |
| **Cargo** | Rust パッケージマネージャ |

## 環境変数設定

### PATH 設定（自動設定済み）
```bash
/home/admin/.local/bin
/home/admin/.cargo/bin
/home/linuxbrew/.linuxbrew/opt/openjdk@21/bin
/home/linuxbrew/.linuxbrew/bin
/home/linuxbrew/.linuxbrew/sbin
/usr/local/bin
/usr/bin
/bin
/usr/local/games
/usr/games
```

### XDG Base Directory（Dotfiles 対応）
```bash
XDG_CONFIG_HOME=~/.config      # 設定ファイル
XDG_DATA_HOME=~/.local/share   # データファイル
XDG_CACHE_HOME=~/.cache        # キャッシュ
```

## セットアップスクリプト利用方法

### 自動セットアップ
```bash
# dotfiles ディレクトリに移動
cd ~/.config

# Brewfile から全パッケージをインストール
brew bundle install

# 確認
brew list
```

### 個別インストール
```bash
# 特定のパッケージのみインストール
brew install go
brew install ruby
brew install php
brew install eza
```

## 開発環境の確認

```bash
# 言語バージョン確認
go version
ruby --version
python3 --version
node --version
npm --version
php --version

# Rust 確認
cargo --version
rustc --version

# ツール確認
git --version
docker --version
nvim --version

# CLI ユーティリティ確認
rg --version
fd --version
bat --version
eza --version
```

## 設定ファイルの場所

| ツール | 設定ファイル | 備考 |
|-------|-----------|------|
| **Neovim** | `~/.config/nvim/` | LazyVim ベース |
| **Starship** | `~/.config/starship.toml` | プロンプト設定 |
| **Nushell** | `~/.config/nushell/config.nu` | シェル設定 |
| **WezTerm** | `~/.config/wezterm/` | ターミナル設定 |
| **PowerShell** | `~/.config/powershell/` | Windows 用設定 |

## トラブルシューティング

### Homebrew パッケージが見つからない場合
```bash
# Homebrew のアップデート
brew update

# キャッシュをクリア
brew cleanup
```

### PATH が正しく設定されていない場合
```bash
# シェル設定を再読み込み
exec bash

# または
source ~/.bashrc
```

### パッケージのアンインストール
```bash
brew uninstall <パッケージ名>
```

## 参考リンク

- [Homebrew 公式](https://brew.sh/)
- [Neovim 公式](https://neovim.io/)
- [Starship 公式](https://starship.rs/)
- [dotfiles リポジトリ](https://github.com/warasugitewara/dotfiles)
