
const FORGE_HOME = "D:/sd-webui-forge-neo"
const COMFY_HOME = "D:/ComfyUI"
const SD_DIR     = "D:/sd-webui-forge-neo/models/Stable-diffusion"

# ------------------------------------------------------------
#  Stable Diffusion WebUI Forge Neo
# ------------------------------------------------------------
export def forge [
    --baseline              # 最適化フラグを外して素で起動 (A/B計測の基準用)
    --streams: int = 3      # --cuda-stream の本数 (Forge既定は2)
    --sage                  # SageAttention を使う (sm86 なので fp16_cuda 固定)
    --xformers              # xformers を使う
    --autotune              # cudnn.benchmark。解像度固定時のみ有効、比較中は外す
    --bf16-vae              # VAE を bf16 に。fp16 の NaN 問題を避けつつ省メモリ
    --reserve: float        # OS/ブラウザ用に確保する VRAM (GB)
    --tiled: int            # VAE タイル化 (64 / 128 / 256 / 512)
    --no-hashing            # sha256 を省略。ただし hash は cache.json に永続化されるので
                            # 効くのは各モデルの初回ロードのみ
    --api                   # API を有効化
    --port: int             # ポート番号 (既定 7860)
    ...extra: string        # その他 ("--foo" のようにクォートする)
] {
    if $tiled != null and $tiled not-in [64 128 256 512] {
        error make { msg: $"--tiled は 64/128/256/512 のいずれか \(指定: ($tiled)\)" }
    }

    let venv    = ([$FORGE_HOME "venv"] | path join)
    let scripts = ([$venv "Scripts"] | path join)
    let python  = ([$scripts "python.exe"] | path join)

    mut flags = if $baseline {
        ["--uv" "--cuda-malloc" "--forge-ref-comfy-home" $COMFY_HOME]
    } else {
        [
            "--uv"                          # 排他グループ: --uv-symlink / --uv-local-cache と併記不可
            "--cuda-malloc"
            "--cuda-stream" ($streams | into string)
            "--pin-shared-memory"
            "--expandable-segments"
            "--force-non-blocking"
            "--fast-fp16"
            "--forge-ref-comfy-home" $COMFY_HOME
        ]
    }

    if $sage        { $flags = ($flags | append ["--sage" "--sage-function" "fp16_cuda"]) }
    if $xformers    { $flags = ($flags | append "--xformers") }
    if $autotune    { $flags = ($flags | append "--autotune") }
    if $bf16_vae    { $flags = ($flags | append "--bf16-vae") }
    if $no_hashing  { $flags = ($flags | append "--no-hashing") }
    if $api         { $flags = ($flags | append "--api") }
    if $reserve != null { $flags = ($flags | append ["--reserve-vram" ($reserve | into string)]) }
    if $tiled   != null { $flags = ($flags | append ["--tiled-conv2d" ($tiled | into string)]) }
    if $port    != null { $flags = ($flags | append ["--port" ($port | into string)]) }

    let args = ($flags | append $extra | str join " ")

    # Windows は Path / Unix は PATH
    let path_key = if ("Path" in $env) { "Path" } else { "PATH" }
    let vars = {
        VIRTUAL_ENV: $venv          # これが無いと uv pip が venv を見つけられない
        COMMANDLINE_ARGS: $args     # shlex.split される → パスは / 区切り・スペース禁止
        SD_WEBUI_RESTART: "tmp/restart"
        ERROR_REPORTING: "FALSE"
    } | insert $path_key ($env | get $path_key | prepend $scripts)

    print $"(ansi dark_gray)($args)(ansi reset)"

    cd $FORGE_HOME
    with-env $vars {
        loop {
            ^$python launch.py
            if not ("tmp/restart" | path exists) { break }
            print $"(ansi yellow)restarting Forge Neo...(ansi reset)"
        }
    }
}

# ------------------------------------------------------------
#  ComfyUI
# ------------------------------------------------------------
export def comfy [
    --reserve: float = 1.0  # OS/ブラウザ用に確保する VRAM (GB)。iGPU無しなので既定で確保
    --port: int             # ポート番号 (既定 8188)
    ...extra: string
] {
    let venv    = ([$COMFY_HOME "venv"] | path join)
    let scripts = ([$venv "Scripts"] | path join)
    let python  = ([$scripts "python.exe"] | path join)

    mut flags = [
        "--reserve-vram" ($reserve | into string)
        "--fast" "fp16_accumulation"    # fp8_matrix_mult は Ampere では無意味
    ]
    if $port != null { $flags = ($flags | append ["--port" ($port | into string)]) }
    let args = ($flags | append $extra)

    let path_key = if ("Path" in $env) { "Path" } else { "PATH" }
    let vars = { VIRTUAL_ENV: $venv }
        | insert $path_key ($env | get $path_key | prepend $scripts)

    cd $COMFY_HOME
    with-env $vars { ^$python main.py ...$args }
}

# ------------------------------------------------------------
#  モデル取得
# ------------------------------------------------------------

# Hugging Face から単一ファイルを取って所定の場所へ移す
export def hf-get [
    repo: string            # 例: circlestone-labs/Anima
    file: string            # 例: split_files/vae/qwen_image_vae.safetensors
    dest: string = $SD_DIR  # 配置先ディレクトリ
] {
    let staging = ($nu.temp-path | path join "hf-staging")
    ^hf download $repo $file --local-dir $staging
    mkdir $dest
    mv ($staging | path join $file) $dest
    ls ($dest | path join ($file | path basename)) | select name size
}

# Civitai のモデルIDからバージョン一覧を引く
export def civitai-versions [
    model_id: int           # 例: 827184 (WAI-illustrious-SDXL)
] {
    http get $"https://civitai.com/api/v1/models/($model_id)"
    | get modelVersions
    | select id name publishedAt
}

# Civitai から特定バージョンをダウンロード
#   要 $env.CIVITAI_TOKEN (private 層で設定すること)
export def civitai-get [
    version_id: int         # civitai-versions で確認した id
    --name: string          # 保存ファイル名 (省略時は version_id.safetensors)
    --dest: string = $SD_DIR
] {
    if ($env.CIVITAI_TOKEN? | is-empty) {
        error make { msg: "CIVITAI_TOKEN が未設定です" }
    }
    let filename = if ($name | is-empty) { $"($version_id).safetensors" } else { $name }
    let out = ([$dest $filename] | path join)

    mkdir $dest
    # トークンは URL ではなくヘッダで渡す。
    # curl は別ホストへのリダイレクト時に Authorization を落とすので CDN でも壊れない。
    ^curl.exe -L --progress-bar -H $"Authorization: Bearer ($env.CIVITAI_TOKEN)" -o $out $"https://civitai.com/api/download/models/($version_id)"

    let info = (ls $out | first)
    if $info.size < 100mb {
        print $"(ansi red)警告: ($info.size) しかありません。HTMLエラーページの可能性があります(ansi reset)"
    }
    $info | select name size
}

# ------------------------------------------------------------
#  確認
# ------------------------------------------------------------

# チェックポイント一覧
export def models [] {
    ls $SD_DIR
    | where name =~ '\.safetensors$'
    | select name size modified
    | update name { path basename }
    | sort-by name
}

# GPU の状態
export def vram [] {
    ^nvidia-smi --query-gpu=name,memory.used,memory.total,utilization.gpu,temperature.gpu --format=csv,noheader,nounits
    | lines
    | split column -c ', ' name used total util temp
    | into int used total util temp
    | insert free { $in.total - $in.used }
    | select name used free total util temp
}
