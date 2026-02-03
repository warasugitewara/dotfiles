# 💤 LazyVim Configuration

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## 📋 Features

### 🎮 Discord Rich Presence (cord.nvim)

This configuration includes **cord.nvim**, a Discord Rich Presence plugin that displays your Neovim activity on Discord.

#### Japanese / 日本語

**cord.nvimについて**

Discord Rich Presenceプラグインを統合し、Neovimでの作業状況をDiscordで表示します。

**表示される情報：**
- 📝 編集中のファイル名
- 📁 作業中のワークスペース名
- ⏱️ 作業時間のタイムスタンプ
- 🎨 ファイルタイプに応じたアイコン

**設定ファイル：** `lua/plugins/cord.lua`

**機能：**
- ファイル編集状況のリアルタイム表示
- ワークスペース情報の自動検出
- アイドル状態の自動検出
- カスタマイズ可能なテキストテンプレート

#### English

**About cord.nvim**

Integrates Discord Rich Presence plugin to display your Neovim activity on Discord.

**Information Displayed:**
- 📝 Name of the file being edited
- 📁 Workspace name you're working in
- ⏱️ Timestamp of editing duration
- 🎨 Icons based on file type

**Configuration File:** `lua/plugins/cord.lua`

**Features:**
- Real-time display of file editing status
- Automatic workspace detection
- Idle state detection
- Customizable text templates

---

## 📦 Wezterm Configuration

Terminal emulator configuration files are included in the `wezterm/` directory.

- `wezterm.lua` - Main configuration
- `keybinds.lua` - Keybinding settings

---

For more details, visit the [documentation](https://lazyvim.github.io/installation).
