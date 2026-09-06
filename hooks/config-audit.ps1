# ConfigChange - append an audit line when settings/skills change during a session. async; best-effort.
try {
    $raw = [Console]::In.ReadToEnd(); if (-not $raw) { exit 0 }
    $in  = $raw | ConvertFrom-Json
    $dir = Join-Path $env:USERPROFILE '.claude/logs'
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
    $rec = @{
        timestamp = (Get-Date -Format o)
        source    = $in.config_source
        changed   = $in.changed_keys
        cwd       = $in.cwd
    } | ConvertTo-Json -Compress
    Add-Content -Path (Join-Path $dir 'config-audit.log') -Value $rec
} catch {}
exit 0
