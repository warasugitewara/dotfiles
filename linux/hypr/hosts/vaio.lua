-- VAIO Pro 13 (SVP1321A2J) 用の差分。hyprland.lua の末尾から読み込まれる。
-- 見た目とキーバインドは arch-dev (W-dev-pc) の mkhypr.py と揃えている。
-- テーマ素材は dotfiles-sec の ~/.local/share/hypr-rice/deploy-rice.sh が配置する。

-- 内蔵 13.3" FHD
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1.25",
})

-- 日本語キーボード
hl.config({
    input = {
        kb_layout = "jp",
        touchpad  = {
            natural_scroll = true,
        },
    },
})

-- HD 4400 (Haswell) の VA-API は i965。共通設定の nvidia を上書きする。
hl.env("LIBVA_DRIVER_NAME", "i965")

-- 共通の自動起動に加えて、アイドル管理・通知・壁紙・音量 OSD・認証エージェントを起動する
hl.on("hyprland.start", function ()
    hl.exec_cmd("hypridle")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)


----------------------------
---- RICE (arch-dev と共通) ----
----------------------------
-- Adapta Nokto 系 (WezTerm の #1a1a1a / Neovim 透過 と揃える)。
-- HD 4400 は blur / shadow が重いので使わず、角丸・グラデーション枠・アニメで見せる

-- 足立レイのカーソル (~/.local/share/icons/AdachiRei)。48x48 のドット絵しか持たないので 48 固定。
-- テーマが無ければ ~/.icons/default 経由で Bibata-Modern-Ice に落ちる
hl.env("XCURSOR_THEME", "AdachiRei")
hl.env("XCURSOR_SIZE", "48")
hl.env("HYPRCURSOR_THEME", "AdachiRei")
hl.env("HYPRCURSOR_SIZE", "48")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("WEZTERM_CONFIG_FILE", os.getenv("HOME") .. "/.config/wezterm-host/wezterm.lua")

hl.config({
    general = {
        gaps_in  = 6,
        gaps_out = 14,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(00bcd4ff)", "rgba(00ff99ff)"}, angle = 45 },
            inactive_border = "rgba(37474faa)",
        },
    },
    decoration = {
        rounding = 12,
        active_opacity   = 1.0,
        inactive_opacity = 0.94,
        dim_inactive = false,
        shadow = { enabled = false },
        blur   = { enabled = false },
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
        background_color = 0xff1a1a1a,
    },
})

-- ランチャーは rofi (テーマを揃えるため)。共通の SUPER + R (hyprlauncher) を外してから付け直す。
-- unbind しないと両方が起動する
hl.unbind("SUPER + R")
hl.bind("SUPER + R",       hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("SUPER + X",       hl.dsp.exec_cmd("powermenu"))
hl.bind("SUPER + N",       hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind("SUPER + L",       hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + F",       hl.dsp.window.fullscreen())
hl.bind("Print",           hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
hl.bind("SHIFT + Print",   hl.dsp.exec_cmd("grim - | wl-copy"))

-- ダイアログ類はフローティングで中央に
for _, cls in ipairs({ "pavucontrol", "org.pulseaudio.pavucontrol", "nwg-look", "qt6ct", "org.gnome.Loupe", "mpv", "blueman-manager", "nm-connection-editor" }) do
    hl.window_rule({
        name  = "float-" .. cls,
        match = { class = "^(" .. cls .. ")$" },
        float  = true,
        center = true,
    })
end
