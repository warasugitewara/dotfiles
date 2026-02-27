# dotfiles

個人用dotfilesリポジトリ。Linux, macOS, Windows11 のクロスプラットフォーム対応。

## クイックスタート

### 環境構築（新しいマシンでの初期セットアップ）

```bash
# 1. dotfiles をクローン
git clone https://github.com/warasugitewara/dotfiles ~/.config

# 2. Homebrew インストール（まだの場合）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Brewfile から開発環境をインストール
cd ~/.config
brew bundle install

# 4. シェルの再起動
exec bash
```

### 設定ファイルのみ利用（既存環境の場合）

```bash
git clone https://github.com/warasugitewara/dotfiles ~/.config
```

## 構成

| ディレクトリ | 説明 |
|-----------|------|
| **nvim** | Neovim 設定 (LazyVim ベース) |
| **nushell** | Nushell シェル設定 |
| **powershell** | PowerShell 設定 (Windows/PowerShell7) |
| **wezterm** | WezTerm ターミナルエミュレーター設定 |
| **thefuck** | thefuck コマンド修正ツール設定 |
| **scoop** | Scoop パッケージマネージャー設定 (Windows) |
| **starship.toml** | Starship プロンプト設定 (共通) |
| **Brewfile** | Homebrew パッケージリスト（自動セットアップ用） |

## 環境

- **OS**: Linux, macOS, Windows 11
- **シェル**: Bash, Nushell, PowerShell 7
- **エディタ**: Neovim
- **ターミナル**: WezTerm
- **スタイル**: Starship プロンプト

## XDG Base Directory 対応

すべての設定は XDG Base Directory Specification に準拠しており、以下の環境変数で管理されます：

```
XDG_CONFIG_HOME=~/.config      (設定ファイル)
XDG_DATA_HOME=~/.local/share   (データファイル)
XDG_CACHE_HOME=~/.cache        (キャッシュ)
```

### Linux/macOS での動作確認方法

```bash
# 設定の確認
echo $XDG_CONFIG_HOME

# シェル設定のロード
source ~/.config/nushell/config.nu    # Nushell
source ~/.config/powershell/...       # PowerShell 7 (pwsh)

# Neovim の起動
nvim
```

### Windows での動作確認方法

PowerShell 7 (`pwsh`) の場合：

```powershell
# プロファイルロード確認
$PROFILE

# または手動でロード
. $PROFILE
```

## 主な設定ファイル

### Neovim (`nvim/`)
- **lazy.lua**: プラグインマネージャー LazyVim 設定
- **plugins/**: 各プラグインの個別設定
- **config/**: キーマップ、オプション、自動コマンド

### Nushell (`nushell/`)
- **config.nu**: メイン設定ファイル
- **env.nu**: 環境変数設定

### PowerShell (`powershell/`)
- **Microsoft.PowerShell_profile.ps1**: プロファイル設定
- **powershell.config.json**: PowerShell 設定

### Starship (`starship.toml`)
シェルプロンプトのカスタマイズ。Git ブランチ表示、コマンド実行時間、ユーザー情報などを設定。

## ライセンス

MIT





