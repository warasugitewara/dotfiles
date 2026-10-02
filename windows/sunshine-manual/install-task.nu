#!/usr/bin/env nu
# SunshineService を「手動」起動に保つタスクをタスクスケジューラに登録する（管理者で 1 回だけ実行すればよい）。
#
#   gsudo nu install-task.nu              登録して即実行（既存タスクがあれば作り直す）
#   gsudo nu install-task.nu --uninstall  登録解除
#
# Sunshine は更新時に起動種別を Automatic へ戻し、常駐すると WezTerm の透過が効かなくなる。
# OS 起動時と、SunshineService の起動種別変更（System イベント 7040）時に、
# Automatic なら Manual に戻してサービスを停止する。Moonlight で使うときは手動で起動する。

const TASK_NAME = "Sunshine Keep Manual"

# Automatic のときだけ直す（自分の変更で 7040 が再発火しても何もしない）
const FIX_COMMAND = "$s = Get-Service SunshineService -ErrorAction SilentlyContinue; if ($s -and $s.StartType -eq 'Automatic') { Set-Service SunshineService -StartupType Manual; Stop-Service SunshineService -Force }"

const EVENT_QUERY = "&lt;QueryList&gt;&lt;Query Id=\"0\" Path=\"System\"&gt;&lt;Select Path=\"System\"&gt;*[System[Provider[@Name='Service Control Manager'] and EventID=7040]] and *[EventData[Data[@Name='param4']='SunshineService']]&lt;/Select&gt;&lt;/Query&gt;&lt;/QueryList&gt;"

def build-xml [] {
    let arguments = ("-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command \"" + $FIX_COMMAND + "\"")

    $"<?xml version=\"1.0\" encoding=\"UTF-16\"?>
<Task version=\"1.4\" xmlns=\"http://schemas.microsoft.com/windows/2004/02/mit/task\">
  <RegistrationInfo>
    <Description>SunshineService の起動種別が Automatic に戻されたら Manual に戻して停止する（WezTerm 透過対策）</Description>
  </RegistrationInfo>
  <Triggers>
    <BootTrigger>
      <Enabled>true</Enabled>
    </BootTrigger>
    <EventTrigger>
      <Enabled>true</Enabled>
      <Subscription>($EVENT_QUERY)</Subscription>
    </EventTrigger>
  </Triggers>
  <Principals>
    <Principal id=\"Author\">
      <UserId>S-1-5-18</UserId>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <ExecutionTimeLimit>PT5M</ExecutionTimeLimit>
    <Priority>7</Priority>
    <IdleSettings>
      <StopOnIdleEnd>false</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
  </Settings>
  <Actions Context=\"Author\">
    <Exec>
      <Command>powershell.exe</Command>
      <Arguments>($arguments)</Arguments>
    </Exec>
  </Actions>
</Task>"
}

def main [--uninstall] {
    if $uninstall {
        ^schtasks /Delete /TN $TASK_NAME /F
        print $"タスク '($TASK_NAME)' を削除しました"
        return
    }

    let utf8_path = ($nu.temp-dir | path join "sunshine-manual.utf8.xml")
    let xml_path = ($nu.temp-dir | path join "sunshine-manual.xml")

    (build-xml) | save --force --raw $utf8_path

    # schtasks /XML は UTF-16 しか受け付けないため、PowerShell で再エンコードする
    ^powershell -NoProfile -Command ("[IO.File]::WriteAllText('" + $xml_path
        + "', [IO.File]::ReadAllText('" + $utf8_path
        + "', [Text.Encoding]::UTF8), [Text.Encoding]::Unicode)")

    ^schtasks /Create /TN $TASK_NAME /XML $xml_path /F
    rm --force $utf8_path $xml_path

    # 現在 Automatic になっている分をすぐ直す
    ^schtasks /Run /TN $TASK_NAME

    print ""
    print $"タスク '($TASK_NAME)' を登録して実行しました:"
    ^schtasks /Query /TN $TASK_NAME /FO LIST
}
