# Zellij Configuration

ターミナルマルチプレクサ Zellij の設定ファイル。

**用途**: Chromebook の ChromeOS Terminal / Secure Shell (hterm) から SSH で接続した際は
WezTerm の機能が一切使えないため、Zellij 側で WezTerm と同じ操作感を再現する。
Hyprland 上で直接作業する場合は WezTerm を使うので Zellij は不要。

## インストール

### 1. Zellij のインストール

```bash
# Arch
sudo pacman -S zellij

# もしくはバイナリ配置
mkdir -p ~/.local/bin
curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz -C ~/.local/bin
```

### 2. 設定ファイルのセットアップ

dotfiles から symlink する（`~/.config/zellij` → `dotfiles/linux/zellij`）。

```bash
ln -sfn ~/dotfiles/linux/zellij ~/.config/zellij
zellij setup --check   # CONFIG FILE: Well defined. が出ればOK
```

## キーバインド

WezTerm (`dotfiles/wezterm/keybinds.lua`) の移植。
**LEADER = `Ctrl + q`**（WezTerm の `config.leader` と同一）。
Zellij の `tmux` モードを LEADER として流用しており、1 アクションごとに Normal へ復帰する
ので WezTerm の one-shot leader と同じ挙動になる。

### LEADER (`Ctrl + q`) 配下 — WezTerm と完全一致

| 操作 | キー | WezTerm 側 |
|------|------|-----------|
| 下に分割 | `LEADER d` | `SplitVertical` |
| 右に分割 | `LEADER r` | `SplitHorizontal` |
| Pane を閉じる | `LEADER x` | 同じ |
| Pane 移動 | `LEADER h` / `j` / `k` / `l` | 同じ |
| Pane ズーム | `LEADER z` | 同じ |
| Pane サイズ調整モード | `LEADER s` | `resize_pane` key table |
| Pane 移動モード | `LEADER a` | `activate_pane` key table |
| Copy モード相当 | `LEADER [` | `ActivateCopyMode` |
| タブを左/右へ入れ替え | `LEADER {` / `}` | 同じ |
| 新規タブ | `LEADER t` | `SUPER t` から移設 |
| タブを閉じる | `LEADER Q` | `SUPER w` から移設 |
| タブ直接切替 | `LEADER 1`〜`9` | `SUPER 1`〜`9` から移設 |
| 次 / 前のタブ | `LEADER n` / `p` | `CTRL Tab` / `CTRL SHIFT Tab` の代替 |
| セッション一覧（= workspace） | `LEADER w` / `W` | `ShowLauncherArgs WORKSPACES` の代替 |
| デタッチ | `LEADER D` | — |
| `Ctrl+q` 自体を送る | `LEADER Ctrl+q` | 同じ |

### モード内のキー

| モード | キー |
|--------|------|
| Resize (`LEADER s`) | `hjkl` 拡大 / `HJKL` 縮小 / `+` `-` / `Enter`・`Esc` で抜ける |
| Pane (`LEADER a`) | `hjkl` 移動 / `d` `r` 分割 / `x` 閉じる / `z` ズーム / `w` フローティング / `c` リネーム |
| Scroll (`LEADER [`) | `j` `k` 行 / `Ctrl+f` `Ctrl+b` ページ / `Ctrl+d` `Ctrl+u` 半ページ / `G` 最下部 / `[` `]` プロンプト間 / `/` 検索 / `y` コピー / **`e` で nvim にスクロールバックを流す** / `q` 終了 |
| Search | `n` / `N` 次・前 / `c` 大小区別 / `w` ラップ / `o` 単語一致 |

### Alt 系（leader を押さない直接操作）

hterm は `Alt` を ESC プレフィックスで送るのでそのまま届く。LEADER 配下と併記してある。

| 操作 | キー |
|------|------|
| 下分割 / 右分割 | `Alt + d` / `Alt + r` |
| Pane を閉じる | `Alt + x` |
| Pane 移動（端でタブを跨ぐ） | `Alt + h` / `j` / `k` / `l` |
| ズーム / フローティング | `Alt + z` / `Alt + f` |
| 新規タブ / タブを閉じる | `Alt + c` / `Alt + q` |
| 前のタブ / 次のタブ | `Alt + w` / `Alt + t` |
| タブ直接切替 | `Alt + 1`〜`9` |
| Pane サイズ増減 | `Alt + =` / `Alt + -` |
| Locked モード（誤爆防止） | `Alt + g`（`Ctrl+g` で復帰） |

## WezTerm と同じにできないもの

いずれも**ターミナルエミュレータ側の機能**か、**hterm がキーを送れない**ことが原因で、
Zellij の設定では解決できない。

| WezTerm バインド | 理由 / 代替 |
|---|---|
| `CTRL +` / `-` / `0` フォントサイズ | エミュレータの機能。hterm 側の設定で変更する。Zellij では `Alt + =` / `-` を pane リサイズに割当 |
| `ALT Enter` フルスクリーン | エミュレータの機能。Zellij の `ToggleFocusFullscreen` は pane ズームで別物 |
| `SUPER c` / `v` コピー・ペースト | Super キーは端末に届かず ChromeOS も OS 側で奪う。hterm の `Ctrl+Shift+C/V`、または `copy_on_select true`（有効済み）でマウス選択コピー |
| `SUPER p` / `CTRL SHIFT p` コマンドパレット | Zellij に相当機能なし |
| `CTRL Tab` / `CTRL SHIFT Tab` | hterm は kitty keyboard protocol (CSI u) 非対応のため `Tab` と区別して送れない。`LEADER n` / `p`、`Alt + t` / `w` で代替 |
| `CTRL SHIFT r` 設定リロード | Zellij は `config.kdl` 保存で自動反映 |
| `CTRL SHIFT [` PaneSelect | 相当機能なし（`LEADER a` の Pane モードで代替） |
| `LEADER $` workspace リネーム | キーバインド化不可。`zellij action rename-session <名前>` または `LEADER w` の session-manager 内から |
| copy モードの `f` / `t` ジャンプ、`v` / `V` / `Ctrl+v` 範囲選択 | Zellij Scroll モードに該当機能なし。`LEADER [` → `e` で nvim に流せば本来の vim 操作が使える（実質上位互換） |

## その他の設定

| 項目 | 値 | 由来 |
|---|---|---|
| `scroll_buffer_size` | 90000 | WezTerm `scrollback_lines = 90000` に合わせた |
| `scrollback_editor` | `/usr/bin/nvim` | `$EDITOR` 未設定でも `EditScrollback` が動くよう明示 |
| `copy_on_select` | `true` | `SUPER c` の代替 |
| `default_layout` | `compact` | ステータスバー 1 行（モード表示あり） |
| `ui.pane_frame_type` | `round` | — |

## 使用方法

```bash
zellij                      # 新規セッション開始
zellij list-sessions        # セッション一覧
zellij attach <name>        # 既存セッションに接続
zellij action rename-session <name>   # セッション（= workspace）のリネーム
```

初回起動時に "About Zellij" のフローティングペインが出る場合は `Esc` で閉じる
（表示中はキー入力が全てそのプラグインに吸われる）。

## 設定ファイル

- `config.kdl` — Zellij メイン設定
  - `normal` / `tmux` … LEADER (`Ctrl+q`) 方式のキーバインド
  - `resize` / `pane` / `scroll` / `search` … WezTerm の key table 相当
  - `shared_except "locked"` … Alt 系の直接操作
  - UI・テーマ・レイアウト・スクロールバック設定
