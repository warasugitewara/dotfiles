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
| **Rust** | 1.93.1 | `brew install rustup-init` 後に `rustup-init` を実行 |
| **Java** | GraalVM 25.0.2 | 公式アーカイブを展開（[GraalVM のインストール](#graalvm-のインストール)参照） |
| **PHP** | 8.5.3 | `brew install php` |

> バージョンは動作確認時点のものです。Homebrew 経由のパッケージは `brew upgrade` で更新されるため、目安として扱ってください。

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

## GraalVM のインストール

GraalVM は Linux 版 Homebrew では配布されていないため、[公式ダウンロードページ](https://www.graalvm.org/downloads/)のアーカイブを展開して使います。

```bash
# GraalVM for JDK 25 (Linux x64) を取得・展開
curl -LO https://download.oracle.com/graalvm/25/latest/graalvm-jdk-25_linux-x64_bin.tar.gz
mkdir -p ~/.local/share/java
tar -xzf graalvm-jdk-25_linux-x64_bin.tar.gz -C ~/.local/share/java

# ~/.bashrc に追記（ディレクトリ名は展開されたものに合わせる）
export JAVA_HOME="$HOME/.local/share/java/graalvm-jdk-25.0.2+XX.X"
export PATH="$JAVA_HOME/bin:$PATH"

# 確認
java --version
```

## 環境変数設定

### PATH 設定

| パス | 追加元 |
|------|-------|
| `~/.local/bin` | Debian 標準の `~/.profile` |
| `~/.local/share/cargo/bin` | rustup（`CARGO_HOME` を XDG 準拠に移動済みのため `~/.cargo/bin` ではない） |
| `~/.local/share/ruby/gems/bin` | `linux/bashrc.xdg-config`（`GEM_HOME`） |
| `$JAVA_HOME/bin`（GraalVM） | `~/.bashrc` に手動追記（上記参照） |
| `/home/linuxbrew/.linuxbrew/bin`<br>`/home/linuxbrew/.linuxbrew/sbin` | `brew shellenv`（Homebrew インストーラの案内どおり `~/.bashrc` に追記） |

### XDG Base Directory（Dotfiles 対応）
```bash
XDG_CONFIG_HOME=~/.config      # 設定ファイル
XDG_DATA_HOME=~/.local/share   # データファイル
XDG_CACHE_HOME=~/.cache        # キャッシュ
XDG_STATE_HOME=~/.local/state  # 状態・ログ（npm ログなど）
```

## セットアップスクリプト利用方法

### 自動セットアップ
```bash
# Brewfile のあるディレクトリに移動
cd ~/.config/linux

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
java --version

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
| **Zellij** | `~/.config/zellij/config.kdl` | マルチプレクサ設定 |
| **Git** | `~/.config/git/config` | `GIT_CONFIG_GLOBAL` で指定 |
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
- [GraalVM 公式ダウンロード](https://www.graalvm.org/downloads/)
- [Neovim 公式](https://neovim.io/)
- [Starship 公式](https://starship.rs/)
- [dotfiles リポジトリ](https://github.com/warasugitewara/dotfiles)
