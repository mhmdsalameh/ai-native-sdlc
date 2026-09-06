# PostToolUse (Bash) - append each command to a log. Runs async; never blocks. Best-effort.
try {
    $raw = [Console]::In.ReadToEnd(); if (-not $raw) { exit 0 }
    $in  = $raw | ConvertFrom-Json
    $cmd = $in.tool_input.command; if (-not $cmd) { exit 0 }
    $dir = Join-Path $env:USERPROFILE '.claude/logs'
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
    $line = "{0}`t{1}`t{2}`t{3}" -f (Get-Date -Format o), $in.session_id, $in.cwd, ($cmd -replace "`r?`n",' ')
    Add-Content -Path (Join-Path $dir 'bash-commands.log') -Value $line
} catch {}
exit 0
