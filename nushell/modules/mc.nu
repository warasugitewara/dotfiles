# ================================================
# mc - Prism インスタンスのワールドを restic で PC 間同期する
#   リポジトリ: $env.MC_SYNC_DIR/restic   ロック: $env.MC_SYNC_DIR/locks/<world>.lock
#   パスワード: $env.MC_SYNC_PASSWORD_FILE（env.local.nu で設定）
#   流れ: mc pull <instance> <world> → 遊ぶ → ゲームを終了 → mc push <instance> <world>
#   pull でロックを取り、push で外す。他の PC がロック中なら pull/push を止める（--force で無視）
# ================================================

def sync-dir [] {
    let dir = ($env.MC_SYNC_DIR? | default "")
    if ($dir | is-empty) { error make { msg: "MC_SYNC_DIR が未設定です（env.local.nu）" } }
    if not ($dir | path exists) { error make { msg: $"($dir) に届きません（NAS が未接続？）" } }
    $dir
}

def --wrapped rs [...args] {
    let pass = ($env.MC_SYNC_PASSWORD_FILE? | default "")
    if ($pass | is-empty) or not ($pass | path exists) {
        error make { msg: "MC_SYNC_PASSWORD_FILE が未設定か、ファイルがありません" }
    }
    ^restic --repo (sync-dir | path join "restic") --password-file $pass ...$args
}

def instances-dir [] {
    let override = ($env.MC_SYNC_INSTANCES_DIR? | default "")
    if ($override | is-not-empty) { return $override }
    if $nu.os-info.name == "windows" {
        $env.APPDATA | path join "PrismLauncher" "instances"
    } else {
        $nu.home-dir | path join ".local" "share" "PrismLauncher" "instances"
    }
}

def saves-dir [instance: string] { instances-dir | path join $instance "minecraft" "saves" }
def world-path [instance: string, world: string] { saves-dir $instance | path join $world }
def lock-path [world: string] { sync-dir | path join "locks" $"($world).lock" }
def me [] { sys host | get hostname }
def now [] { date now | format date "%Y-%m-%d %H:%M:%S" }
def norm [p: string] { $p | str replace -a '\' '/' | str lowercase }

def read-lock [world: string] {
    let lock = (lock-path $world)
    if ($lock | path exists) { open --raw $lock | from nuon } else { null }
}

# 他の PC がロックを持っていたら止める
def check-lock [world: string, force: bool] {
    let l = (read-lock $world)
    if $l != null and $l.host != (me) and not $force {
        error make { msg: $"($l.host) が ($l.time) から遊んでいます。向こうで mc push するか、--force を付けてください" }
    }
}

# そのインスタンスの Minecraft が起動中か（java のコマンドラインにインスタンスのパスが含まれるか）
def game-running [instance: string] {
    let dir = (norm (instances-dir | path join $instance))
    ps -l
    | where {|p| ($p.name | str lowercase) =~ '^javaw?(\.exe)?$' }
    | where {|p| (norm ($p.command? | default "")) | str contains $dir }
    | is-not-empty
}

def world-tag [world: string] { $"world:($world)" }

def snapshots [world: string] {
    rs snapshots --json --tag (world-tag $world) | from json | default []
}

# ロックとスナップショットの一覧を表示する
export def "mc status" [world: string] {
    let l = (read-lock $world)
    if $l == null { print "ロック: なし" } else { print $"ロック: ($l.host)（($l.time) から、snapshot ($l.snapshot? | default '-')）" }
    snapshots $world
    | each {|s| { id: $s.short_id, time: ($s.time | into datetime | format date "%Y-%m-%d %H:%M"), host: $s.hostname } }
    | sort-by time --reverse
}

# ワールドを NAS に保存し、ロックを外す
export def "mc push" [
    instance: string   # Prism のインスタンス名
    world: string      # saves/ の下のワールドフォルダ名
    --force            # 他の PC のロックを無視する
] {
    let src = (world-path $instance $world)
    if not ($src | path exists) { error make { msg: $"ワールドがありません: ($src)" } }
    if (game-running $instance) { error make { msg: "ゲームが起動中です。終了してから push してください" } }
    check-lock $world $force

    rs backup $src --host (me) --tag (world-tag $world) --tag $"host:(me)"
    rs forget --tag (world-tag $world) --keep-last 30 --quiet

    let lock = (lock-path $world)
    if ($lock | path exists) { rm $lock }
    print $"push 完了。($world) のロックを外しました"
}

# NAS の最新版でワールドを置き換え、ロックを取る（元のワールドは <world>.before-pull-* に退避）
export def "mc pull" [
    instance: string   # Prism のインスタンス名
    world: string      # saves/ の下のワールドフォルダ名
    --force            # 他の PC のロックを無視する
] {
    if (game-running $instance) { error make { msg: "ゲームが起動中です。終了してから pull してください" } }
    check-lock $world $force

    let snaps = (snapshots $world)
    if ($snaps | is-empty) { error make { msg: $"($world) のスナップショットがありません。最初は遊んだ側で mc push してください" } }
    let latest = ($snaps | sort-by time | last)

    # ワールドのフォルダ以下だけを復元する（親フォルダまで復元すると Windows で C:\Users の属性復元に失敗するため）
    # スナップショット内のパス: Windows で保存したものは C:\a\b → /C/a/b、Linux はそのまま
    let src = ($latest.paths | first)
    let tree = if ($src =~ '^[A-Za-z]:\\') {
        "/" + ($src | str substring 0..0) + "/" + ($src | str substring 3.. | str replace -a '\' '/')
    } else { $src }
    let tmp = ($nu.temp-dir | path join $"mc-sync-(random chars --length 8)")
    let restored = ($tmp | path join $world)
    rs restore $"($latest.id):($tree)" --target $restored
    if not ($restored | path join "level.dat" | path exists) {
        error make { msg: $"復元結果に level.dat がありません: ($restored)" }
    }
    let found = [$restored]

    let saves = (saves-dir $instance)
    mkdir $saves
    let dst = ($saves | path join $world)
    if ($dst | path exists) {
        mv $dst $"($dst).before-pull-(date now | format date '%Y%m%d-%H%M%S')"
        # 退避は新しい 2 個だけ残す
        ls $saves
        | where {|f| ($f.name | path basename) | str starts-with $"($world).before-pull-" }
        | sort-by name
        | drop 2
        | each {|f| rm -r $f.name }
    }
    mv ($found | first) $dst
    rm -r $tmp

    { host: (me), time: (now), snapshot: $latest.short_id } | to nuon | save -f (lock-path $world)
    print $"pull 完了（snapshot ($latest.short_id)、($latest.hostname) で保存）。($world) のロックを取りました"
}
