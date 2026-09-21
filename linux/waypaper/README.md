# waypaper + linux-wallpaperengine

Steam の Wallpaper Engine で購入した壁紙を Hyprland (Wayland) の背景として再生する。
`waypaper` が GUI、`linux-wallpaperengine` が実際のレンダラー。

> [!IMPORTANT]
> 壁紙データそのものは **このリポジトリに含めない**。Workshop コンテンツの著作権は
> 各作者にあり、リポジトリに置けば再配布にあたる。ここにあるのは設定だけ。

## 必要なパッケージ

```bash
sudo pacman -S --needed waypaper            # GUI
yay -S linux-wallpaperengine-git            # レンダラー (AUR)
```

## Windows 側の壁紙を参照する

デュアルブート環境では、Wallpaper Engine 本体と Workshop データが Windows 側の
Steam ライブラリにある。再ダウンロードは不要で、NTFS を読み取り専用でマウントして
参照すればよい。

### 1. マウント (fstab)

```
UUID=<HDD の UUID>  /mnt/win-hdd0  ntfs3  ro,uid=1000,gid=1000,nofail,x-systemd.device-timeout=10  0 0
```

- `ro` — Windows の休止状態 (hiberfil.sys) で書き込むと NTFS を破損させるため必須
- `nofail` — ディスクが無くても起動を継続する。これが無いと emergency mode に落ちうる
- UUID 指定 — NVMe のデバイス名は起動ごとに入れ替わることがあるため名前では指定しない

### 2. シンボリックリンク

`waypaper` は `linux-wallpaperengine` に `--assets-dir` を渡さず自動検出に任せる。
そのため Linux 側の標準パスから Windows 側の実体が見えるようにしておく。

```bash
B=/mnt/win-hdd0/SteamLibrary/steamapps
S=~/.steam/root/steamapps
mkdir -p "$S/workshop/content"
ln -sfn "$B/common/wallpaper_engine/assets" "$S/common/wallpaper_engine/assets"
ln -sfn "$B/workshop/content/431960"        "$S/workshop/content/431960"
```

## 対応している壁紙の形式

`linux-wallpaperengine` は 4 形式のうち 2 つに対応していない。GUI 上では
プレビュー画像で区別できないため、選んでも何も起きない場合はここを疑う。

| 形式 | 状態 | 備考 |
| --- | --- | --- |
| `scene` | 動く | |
| `video` | 動く | nvdec によるハードウェアデコードが効く |
| `web` | **クラッシュ** | `close symbol missing` で core dump する。回避策なし |
| type なし | **非対応** | `Project type missing`。他の壁紙に設定だけ重ねるプリセット型 |

プリセット型は `project.json` の `dependency` が依存先の Workshop ID を示す。
プリセットの独自設定は失われるが、依存先を直接選べば土台の壁紙は表示できる。

## 設定のポイント

- `linux_wallpaperengine_disable_particles` — パーティクルは最も重い。既定で無効
- `linux_wallpaperengine_no_fullscreen_pause` — `False` にすると全画面アプリ実行中に
  壁紙が自動で停止する。ゲーム中の GPU 負荷を避けたい場合はこちらを推奨
- `linux_wallpaperengine_fps` — 下げるほど負荷が下がる
