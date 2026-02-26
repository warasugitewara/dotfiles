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
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.XDG_DATA_HOME = ($env.HOME | path join ".local" "share")
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")

$env.config.shell_integration.osc133 = false
$env.config.show_banner = false
$env.config.render_right_prompt_on_last_line = true
# Enable ANSI colors and VT100 support
$env.config.use_kitty_protocol = false
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
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
    # Fallback for command not found errors - show suggestions
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
