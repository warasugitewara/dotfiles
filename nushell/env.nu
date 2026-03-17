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
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.


# XDG Base Directory Specification
$env.XDG_CONFIG_HOME = ($nu.home-path | path join ".config")
$env.XDG_DATA_HOME = ($nu.home-path | path join ".local" "share")
$env.XDG_CACHE_HOME = ($nu.home-path | path join ".cache")

# ================================================
# calcpp - CLI Calculator Integration
# ================================================
def calc [...args: string] {
    let calcpp_path = $"($env.LOCALAPPDATA)\\Programs\\calcpp\\calcpp.exe"
    ^$calcpp_path ...$args
}

def calc-with-precision [expr: string, --precision (-p): int = 15] {
    let calcpp_path = $"($env.LOCALAPPDATA)\\Programs\\calcpp\\calcpp.exe"
    
    if ($precision != 15) {
        ^$calcpp_path -p $precision $expr
    } else {
        ^$calcpp_path $expr
    }
}

# 使用例:
#   calc "3 + 5"
#   calc-with-precision "pi" --precision 10
