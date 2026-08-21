# ============================================================
#  Local image generation launchers
# ============================================================
const FORGE_HOME = "D:/sd-webui-forge-neo"
const COMFY_HOME = "D:/ComfyUI"

# Stable Diffusion WebUI Forge Neo
export def forge [
    --sage                  # SageAttention をインストールして使う
    --xformers              # xformers をインストールして使う
    --api                   # API を有効化
    --port: int             # ポート番号 (既定 7860)
    ...extra: string        # その他 ("--foo" のようにクォートする)
] {
    let venv    = ([$FORGE_HOME "venv"] | path join)
    let scripts = ([$venv "Scripts"] | path join)
    let python  = ([$scripts "python.exe"] | path join)

    mut flags = [
        "--uv"
        "--cuda-malloc"
        "--cuda-stream"
        "--pin-shared-memory"
        "--expandable-segments"
        "--forge-ref-comfy-home" $COMFY_HOME
    ]
    if $sage         { $flags = ($flags | append "--sage") }
    if $xformers     { $flags = ($flags | append "--xformers") }
    if $api          { $flags = ($flags | append "--api") }
    if $port != null { $flags = ($flags | append ["--port" ($port | into string)]) }
    let args = ($flags | append $extra | str join " ")

    # Windows は Path / Unix は PATH
    let path_key = if ("Path" in $env) { "Path" } else { "PATH" }
    let vars = {
        VIRTUAL_ENV: $venv                  # これが無いと uv pip がvenvを見つけられない
        COMMANDLINE_ARGS: $args
        SD_WEBUI_RESTART: "tmp/restart"
        ERROR_REPORTING: "FALSE"
    } | insert $path_key ($env | get $path_key | prepend $scripts)

    cd $FORGE_HOME
    with-env $vars {
        loop {
            ^$python launch.py
            if not ("tmp/restart" | path exists) { break }
            print $"(ansi yellow)restarting Forge Neo...(ansi reset)"
        }
    }
}
