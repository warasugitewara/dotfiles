# ================================================
# sky - この PC で動かす ATM10 To the Sky 鯖（~/mc-servers/atm10sky、ポート 25566）
#   sky start  : 別ウィンドウで鯖を起動（コンソールに直接コマンドも打てる）
#   sky stop   : セーブして停止 → NAS に restic でバックアップ
#   sky status : 起動中か・誰がいるか
#   sky cmd    : RCON でコマンドを送る（例: sky cmd list）
#   sky backup : 動いたまま NAS にバックアップ（予約タスクが 3 時間おきに実行。記録は ~/mc-servers/sky-backup.log）
#   バックアップ先は mc.nu と同じリポジトリ（$env.MC_SYNC_DIR/restic）。タグ server:atm10sky
# ================================================

const SKY_DIR = ('~/mc-servers/atm10sky' | path expand)
const SKY_RCON = ('~/mc-servers/mc-rcon.py' | path expand)
const SKY_JAVA = ('~/mc-servers/jre21/bin/java.exe' | path expand)   # 専用コピー（ファイアウォールのルールがこのパスを指す。scoop の更新で変わらないように）
const SKY_NEOFORGE = '21.1.250'
# プロセスを見分ける目印（java のコマンドラインに入れる）
const SKY_MARK = '-Dsky.server=atm10sky'

def sky-pids [] {
    ps -l | where {|p| ($p.command? | default "") | str contains $SKY_MARK } | get pid
}

def sky-rcon [...args: string] {
    ^python3 -I $SKY_RCON ($SKY_DIR | path join "server.properties") ...$args
}

# 鯖を別ウィンドウで起動する
export def "sky start" [] {
    if (sky-pids | is-not-empty) { print "もう起動しています"; return }
    let args = $"@libraries/net/neoforged/neoforge/($SKY_NEOFORGE)/win_args.txt"
    # start の最初の "" はウィンドウタイトル
    ^cmd.exe /c start "ATM10 Sky" /D $SKY_DIR $SKY_JAVA $SKY_MARK "@user_jvm_args.txt" $args nogui
    print "起動しました（完了まで約 3 分）。sky status で確認できます"
}

# 起動中か・誰がいるか
export def "sky status" [] {
    let pids = (sky-pids)
    if ($pids | is-empty) { print "停止中"; return }
    let r = (do { sky-rcon list } | complete)
    if $r.exit_code == 0 { print $"起動中（pid ($pids | str join ',')）: ($r.stdout | str trim)" } else { print $"起動処理中（pid ($pids | str join ',')、RCON はまだ）" }
}

# RCON でコマンドを送る
export def "sky cmd" [...command: string] { sky-rcon ...$command }

# セーブして止め、NAS にバックアップする
export def "sky stop" [
    --no-backup   # バックアップを取らない
] {
    let pids = (sky-pids)
    if ($pids | is-empty) { print "停止中です" } else {
        sky-rcon stop | ignore
        print "停止を待っています…"
        mut n = 0
        while (sky-pids | is-not-empty) {
            if $n >= 180 { error make { msg: "3 分待っても止まりません。ウィンドウを確認してください" } }
            sleep 1sec
            $n += 1
        }
        print "停止しました"
    }
    if $no_backup { return }
    sky-restic
}

# 動いたまま NAS にバックアップする（保存を止めて書き出し → restic → 保存を戻す）
#   予約タスク「ATM10 Sky backup」が 3 時間おきに --if-running 付きで呼ぶ
export def "sky backup" [
    --if-running   # 止まっていたら何もしない（止めたときは sky stop が取っているので）
] {
    if (sky-pids | is-empty) {
        if not $if_running { sky-restic }
        return
    }
    sky-rcon save-off | ignore
    try {
        sky-rcon save-all flush | ignore
        sky-restic
    } catch {|e|
        sky-rcon save-on | ignore
        sky-log $"失敗: ($e.msg)"
        error make { msg: $"バックアップに失敗しました: ($e.msg)" }
    }
    sky-rcon save-on | ignore
}

def sky-log [msg: string] {
    $"(date now | format date '%Y-%m-%d %H:%M:%S') ($msg)\n" | save --append ($SKY_DIR | path dirname | path join "sky-backup.log")
}

# world を NAS の restic に送る。残すのは直近 30 回 ＋ 30 日分の各日最後の 1 つ
def sky-restic [] {
    let repo = ($env.MC_SYNC_DIR? | default "")
    let pass = ($env.MC_SYNC_PASSWORD_FILE? | default "")
    if ($repo | is-empty) or not ($repo | path exists) or ($pass | is-empty) {
        print "NAS かパスワードファイルに届かないので、バックアップは飛ばしました"
        sky-log "飛ばした: NAS かパスワードファイルに届かない"
        return
    }
    let world = ($SKY_DIR | path join "world")
    if not ($world | path exists) { print "world がまだありません"; return }
    let r = ($repo | path join "restic")
    let host = (sys host | get hostname)
    ^restic --repo $r --password-file $pass backup $world --host $host --tag server:atm10sky --exclude session.lock --quiet   # session.lock は鯖が掴んでいて読めない（中身は空の目印）
    ^restic --repo $r --password-file $pass forget --tag server:atm10sky --keep-last 30 --keep-daily 30 --prune --quiet
    sky-log "完了"
    print "バックアップ完了"
}
