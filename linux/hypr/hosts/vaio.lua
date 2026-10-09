-- VAIO Pro 13 (SVP1321A2J) 用の差分。hyprland.lua の末尾から読み込まれる。

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

hl.on("hyprland.start", function ()
    hl.exec_cmd("hypridle")
end)
