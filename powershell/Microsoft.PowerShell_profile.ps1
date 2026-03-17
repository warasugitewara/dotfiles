Invoke-Expression (&starship init powershell)
$env:PYTHONIOENCODING="utf-8"
$env:XDG_CONFIG_HOME="C:\Users\waras\.config"
$env:XDG_DATA_HOME="C:\Users\waras\.local\share"
$env:XDG_CACHE_HOME="C:\Users\waras\.cache"
iex "$(thefuck --alias)"
# Sakura Editor shortcut
function sakura {
    & "C:\Program Files (x86)\sakura\sakura.exe" $args
}
# VLC Media Player shortcut
function vlc {
    & "C:\Program Files\VideoLAN\VLC\vlc.exe" $args
}

# VLC Media Player shortcut
function mpv {
    & "C:\Users\waras\AppData\Local\Programs\mpv.net\mpvnet.exe" $args
}

# 短縮エイリアス（任意）
Set-Alias se sakura
Set-Alias sltrain "C:\Users\waras\sl\sl.exe"

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

# ================================================
# calcpp - CLI Calculator Integration
# ================================================
function calc {
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string]$Expression,
        [int]$Precision = 15
    )
    
    $calcppPath = "C:\Users\$env:USERNAME\AppData\Local\Programs\calcpp\calcpp.exe"
    
    if (-not (Test-Path $calcppPath)) {
        Write-Error "calcpp not found at $calcppPath"
        return
    }
    
    if ($Precision -ne 15) {
        & $calcppPath -p $Precision $Expression
    } else {
        & $calcppPath $Expression
    }
}

Set-Alias -Name cc -Value calc -Scope Global -Force

# 使用例:
#   calc "3 + 5"
#   calc "pi" -Precision 10
#   cc "sqrt(16)"

# Sushida CLI
function sushida {
    & "C:\Users\waras\Workspace\sushida-cli\target\release\sushida.exe" @args
}
$env:Path = if ($env:Path -notlike "*Workspace\sushida-cli\target\release*") { 
    $env:Path + ";C:\Users\waras\Workspace\sushida-cli\target\release" 
} else { 
    $env:Path 
}
