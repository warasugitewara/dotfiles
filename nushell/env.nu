# env.nu
#
# Installed by:
# version = "0.110.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html

# XDG Base Directory Specification
$env.XDG_CONFIG_HOME = ($nu.home-dir | path join ".config")
$env.XDG_DATA_HOME = ($nu.home-dir | path join ".local" "share")
$env.XDG_CACHE_HOME = ($nu.home-dir | path join ".cache")

# ================================================
# calcpp - CLI Calculator Integration (Windows)
#   インストール: https://github.com/PLC-lang/calcpp
# ================================================
def calc [...args] {
    if $nu.os-info.name != "windows" {
        print "calc は Windows 専用 (calcpp) です"
        return
    }
    let calcpp_path = ($nu.home-dir | path join "AppData" "Local" "Programs" "calcpp" "calcpp.exe")
    ^$calcpp_path ...$args
}

def calc-with-precision [expr: string, --precision (-p): int = 15] {
    if $nu.os-info.name != "windows" {
        print "calc-with-precision は Windows 専用 (calcpp) です"
        return
    }
    let calcpp_path = ($nu.home-dir | path join "AppData" "Local" "Programs" "calcpp" "calcpp.exe")

    if ($precision != 15) {
        ^$calcpp_path -p $precision $expr
    } else {
        ^$calcpp_path $expr
    }
}

# ================================================
# Claude Headroom proxy (192.168.1.30:8787)
# ================================================
$env.ANTHROPIC_BASE_URL = "http://192.168.1.30:8787"

# ================================================
# btop4win path (Windows のみ。Linux/macOS では native btop を使用)
# ================================================
if $nu.os-info.name == "windows" {
    $env.PATH = (
        $env.PATH
        | split row (char esep)
        | append 'C:\Users\waras\AppData\Local\Microsoft\WinGet\Packages\aristocratos.btop4win_Microsoft.Winget.Source_8wekyb3d8bbwe\btop4win'
        | uniq
    )
}
