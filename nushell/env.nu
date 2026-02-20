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

use 'C:\Users\waras\Workspace\apple-music-controller\music.nu' *

# XDG Base Directory Specification
$env.XDG_CONFIG_HOME = "C:\\Users\\waras\\.config"
$env.XDG_DATA_HOME = "C:\\Users\\waras\\.local\\share"
$env.XDG_CACHE_HOME = "C:\\Users\\waras\\.cache"

# ================================================
# calcpp - CLI Calculator Integration
# ================================================
alias calc = & 'C:\Users\waras\AppData\Local\Programs\calcpp\calcpp.exe'

def calc-with-precision [expr: string, --precision (-p): int = 15] {
    let username = ($env.USERNAME)
    let calcpp_path = $"C:\\Users\($username)\\AppData\\Local\\Programs\\calcpp\\calcpp.exe"
    
    if ($precision != 15) {
        ^$calcpp_path -p $precision $expr
    } else {
        ^$calcpp_path $expr
    }
}

# 使用例:
#   calc "3 + 5"
#   calc-with-precision "pi" --precision 10
