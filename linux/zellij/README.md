# Zellij Configuration

ターミナルマルチプレクサ Zellij の設定ファイル。

## インストール

### 1. Zellij のインストール

```bash
# ダウンロード＆インストール
mkdir -p ~/.local/bin
curl -L https://github.com/zellij-org/zellij/releases/download/v0.40.0/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz -C ~/.local/bin

# PATH に追加（~/.bashrc または ~/.zshrc に追加）
export PATH="$HOME/.local/bin:$PATH"
```

### 2. 設定ファイルのセットアップ

```bash
# .config/zellij に設定をコピー
mkdir -p ~/.config/zellij
cp zellij/config.kdl ~/.config/zellij/config.kdl
```

## キーバインド

Wezterm のキーバインドに統一されています。

### Pane 操作

| 操作 | キー |
|------|------|
| 右分割（縦） | `Alt + d` |
| 下分割（横） | `Alt + r` |
| Pane を閉じる | `Alt + x` |
| 左移動 | `Alt + h` |
| 下移動 | `Alt + j` |
| 上移動 | `Alt + k` |
| 右移動 | `Alt + l` |
| ズーム表示 | `Alt + z` |

### タブ操作

| 操作 | キー |
|------|------|
| 新規タブ作成 | `Alt + c` |
| タブを閉じる | `Alt + q` |
| 前のタブへ | `Alt + w` |
| 次のタブへ | `Alt + t` |

## 使用方法

```bash
# 新規セッション開始
zellij

# セッション一覧表示
zellij list-sessions

# 既存セッションに接続
zellij attach <session-name>
```

## 設定ファイル

- `config.kdl` - Zellij メイン設定ファイル
  - UI 設定（Pane フレームタイプ）
  - キーバインド定義
  - テーマ・レイアウト設定
