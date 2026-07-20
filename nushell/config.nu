# config.nu
#
# Installed by:
# version = "0.110.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# XDG Base Directory Specification
$env.XDG_CONFIG_HOME = ($nu.home-dir | path join ".config")
$env.XDG_DATA_HOME = ($nu.home-dir | path join ".local" "share")
$env.XDG_CACHE_HOME = ($nu.home-dir | path join ".cache")

$env.config.shell_integration.osc133 = false
$env.config.show_banner = false
$env.config.render_right_prompt_on_last_line = true
$env.config.use_kitty_protocol = false
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# ================================================
# fuck - thefuck integration
# ================================================
def fuck [args?: string] {
    let last_command = (
        history
        | reverse
        | first 1
        | select command
        | get command.0
    )
    let result = (thefuck $last_command | str trim)

    if ($result != "No fucks given" and ($result | str length) > 0) {
        nu -c $result
    } else {
        if ($last_command =~ 'not found') {
            print "💡 Command suggestions:"
            print "  • java: Set JAVA_HOME or download from adoptopenjdk.net"
            print "  • python: Use `py` or install from python.org"
            print "  • python3: Use `py -3` or install Python"
            print "  • node/npm: Download Node.js from nodejs.org"
            print "  • ruby: Download from ruby-lang.org"
            print "  • go: Download from golang.org"
            print "  • docker: Download from docker.com"
        } else {
            print "No fucks given"
        }
    }
}

# ================================================
# fcc - Claude Code を Nvidia NIM プロキシ経由で起動 (Windows)
#   proxy: 192.168.0.100:8082
# ================================================
def "fcc" [...args] {
    with-env {
        ANTHROPIC_BASE_URL: "http://192.168.0.100:8082",
        ANTHROPIC_AUTH_TOKEN: "freecc"
    } {
        ^claude ...$args
    }
}

# ================================================
# llm - deepseek-r1:8b via Ollama (2026-06 upgrade)
#   旧: qwen2.5-coder:7b → 新: deepseek-r1:8b
#   HumanEval ~62%, 思考モード付き, ~5GB VRAM
# ================================================
def llm [...args: string] {
    let ollama_running = (try {
        http get "http://localhost:11434"
        true
    } catch { false })

    if $ollama_running == false {
        print "⏳ Ollamaを起動中..."
        ^cmd /c start "" ollama serve
        sleep 3sec
    }

    print "🤖 deepseek-r1:8b を読み込み中..."

    if ($args | is-empty) {
        ^ollama run deepseek-r1:8b
    } else {
        ^ollama run deepseek-r1:8b ($args | str join " ")
    }
}

# ================================================
# ai - Aider + llm-router
#   オンライン: Claude Sonnet via Headroom Proxy (192.168.1.30:8787)
#              OAuth トークンを ~/.claude/.credentials.json から自動取得
#   オフライン: deepseek-r1:8b via local Ollama
#   設定: ~/llm-router/.env
# ================================================
def ai [] {
    let router_port = 4001
    let ollama_port  = 11434
    let router_dir   = ($nu.home-dir | path join "llm-router")
    let aider_bin    = ($nu.home-dir | path join ".local" "bin" "aider.exe")

    let ollama_running = (try {
        http get $"http://localhost:($ollama_port)"
        true
    } catch { false })

    if $ollama_running == false {
        print "⏳ Ollama起動中..."
        ^cmd /c start "" ollama serve
        sleep 2sec
    }

    let router_running = (try {
        http get $"http://localhost:($router_port)/v1/models"
        true
    } catch { false })

    if $router_running == false {
        print "🔀 Router起動中..."
        ^cmd /c start "" /d $router_dir uvicorn router_server:app --host 0.0.0.0 --port 4001
        sleep 3sec

        let ready = (try {
            http get $"http://localhost:($router_port)/v1/models"
            true
        } catch { false })

        if $ready == false {
            print "❌ Router起動失敗。~/llm-router/ を確認してください"
            return
        }
    }

    let route = (try {
        http get $"http://localhost:($router_port)/v1/models"
        | get data.0.description
    } catch { "unknown" })

    print $"✅ Route: ($route)"
    print "🤖 Aider起動中..."

    ^$aider_bin --model openai/router --openai-api-base $"http://localhost:($router_port)/v1" --openai-api-key dummy
}

# ================================================
# btop - Windows では btop4win、Linux/macOS では native btop を呼ぶ
#   (^ で外部コマンドを強制し、この def 自身への再帰を回避)
# ================================================
def --wrapped btop [...rest] {
    if $nu.os-info.name == "windows" {
        ^btop4win ...$rest
    } else {
        ^btop ...$rest
    }
}

# ================================================
# nano - Windows では nvim、Linux/macOS では native nano を呼ぶ
# ================================================
def --wrapped nano [...rest] {
    if $nu.os-info.name == "windows" {
        ^nvim ...$rest
    } else {
        ^nano ...$rest
    }
}

# typo aliases ＋α
alias ks = ls
alias claer = clear
alias claeer = clear
alias caler = clear
alias cleaer = clear
alias claera = clear
alias caer = clear
alias lcaer = clear
alias cc = clear
alias cat = bat
alias quit = exit
alias :q = exit
alias :q! = exit

# editor aliases
alias vi = nvim
alias vim = nvim
alias nivm = nvim

# Claude Code
alias cr = claude --resume
