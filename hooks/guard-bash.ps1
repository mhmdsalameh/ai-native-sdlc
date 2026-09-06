# PreToolUse (Bash) - block catastrophic shell commands, in ANY project.
# Deny via JSON (exit 0). Fail-open on error. Targets only unambiguous, high-blast-radius commands;
# it is a safety net, not a full policy engine (that is the permission system's job).
$ErrorActionPreference = 'Stop'

function Allow { exit 0 }
function Deny([string]$reason) {
    $o = @{ hookSpecificOutput = @{
        hookEventName            = 'PreToolUse'
        permissionDecision       = 'deny'
        permissionDecisionReason = $reason
    } } | ConvertTo-Json -Depth 6 -Compress
    [Console]::Out.Write($o); exit 0
}

try {
    $raw = [Console]::In.ReadToEnd(); if (-not $raw) { Allow }
    $in  = $raw | ConvertFrom-Json
    $cmd = $in.tool_input.command; if (-not $cmd) { Allow }
    $c = ($cmd -replace '\s+',' ').Trim()

    # [regex, reason] - matching is case-insensitive (-match default).
    $rules = @(
        @('\brm\s+(-[a-zA-Z]*\s+)*-[a-zA-Z]*r[a-zA-Z]*(\s+-[a-zA-Z]+)*\s+(/(\*)?(\s|$)|~/?(\s|$)|\$HOME\b|\.(\s|$))',
          'recursive delete of a root/home/current-directory path (rm -rf on /, ~, $HOME, /*, or .)'),
        @(':\s*\(\s*\)\s*\{\s*:\s*\|\s*:\s*&\s*\}\s*;\s*:', 'fork bomb'),
        @('\bmkfs(\.\w+)?\b',                            'filesystem format (mkfs)'),
        @('\bdd\b[^|;&]*\bof=/dev/(sd|nvme|hd|vd)',      'raw disk overwrite (dd of=/dev/...)'),
        @('>\s*/dev/(sd|nvme|hd|vd)\w',                  'redirect over a raw disk device'),
        @('\bdrop\s+(table|database|schema)\b',          'destructive SQL (DROP TABLE/DATABASE/SCHEMA)'),
        @('\btruncate\s+table\b',                        'destructive SQL (TRUNCATE TABLE)'),
        @('\bgit\s+push\b[^|;&]*(\s--force(?!-with-lease)\b|\s-f\b)', 'git push --force (non-lease)'),
        @('\bchmod\s+-R\s+0*777\s+/(\s|$)',              'chmod -R 777 on /')
    )

    foreach ($r in $rules) {
        if ($c -match $r[0]) {
            Deny "guard-bash: blocked - $($r[1]). If this is genuinely intended, the user must run it themselves or confirm explicitly."
        }
    }
    Allow
}
catch {
    try {
        $d = Join-Path $env:USERPROFILE '.claude/logs'
        if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force $d | Out-Null }
        Add-Content (Join-Path $d 'hooks-error.log') "$(Get-Date -Format o) guard-bash ERROR $($_.Exception.Message)"
    } catch {}
    exit 0
}
