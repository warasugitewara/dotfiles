Invoke-Expression (&starship init powershell)
$env:PYTHONIOENCODING = "utf-8"
$env:XDG_CONFIG_HOME = Join-Path $env:HOME ".config"
$env:XDG_DATA_HOME = Join-Path $env:HOME ".local" "share"
$env:XDG_CACHE_HOME = Join-Path $env:HOME ".cache"

# Initialize thefuck if available
if (Get-Command thefuck -ErrorAction SilentlyContinue) {
    iex "$(thefuck --alias)"
}
