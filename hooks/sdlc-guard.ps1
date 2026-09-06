# AI-native SDLC enforcement guard (PreToolUse).
# Blocks Edit/Write to protected paths and production-deploy Bash commands, but ONLY inside a
# repo that has opted in with .sdlc/config.yaml. Fail-open by design: any error -> allow, so the
# guard can never brick editing globally. Errors are logged to ~/.claude/sdlc-guard.log.
$ErrorActionPreference = 'Stop'

function Allow { exit 0 }
function Block([string]$reason) {
    $out = @{ hookSpecificOutput = @{
        hookEventName            = 'PreToolUse'
        permissionDecision       = 'deny'
        permissionDecisionReason = $reason
    } } | ConvertTo-Json -Depth 6 -Compress
    [Console]::Out.Write($out)
    exit 0
}

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { Allow }
    $in = $raw | ConvertFrom-Json

    $tool = $in.tool_name
    if ($tool -ne 'Edit' -and $tool -ne 'Write' -and $tool -ne 'Bash') { Allow }

    # Walk up from cwd to find .sdlc/config.yaml. No config -> not an SDLC repo -> no-op.
    $dir = $in.cwd; if (-not $dir) { $dir = (Get-Location).Path }
    $cfg = $null; $d = $dir
    while ($d) {
        $c = Join-Path $d '.sdlc/config.yaml'
        if (Test-Path $c) { $cfg = $c; break }
        $p = Split-Path $d -Parent
        if (-not $p -or $p -eq $d) { break }
        $d = $p
    }
    if (-not $cfg) { Allow }
    $lines = Get-Content $cfg
    # Repo root = the directory that contains .sdlc/. Match fragments against paths RELATIVE to it,
    # so an absolute prefix (e.g. a folder literally named "test") can't cause false positives.
    $root = (Split-Path (Split-Path $cfg -Parent) -Parent).Replace('\','/').TrimEnd('/')

    # Read a YAML list block (key: then "- item" lines until the next unindented key).
    function Read-List([string]$key) {
        $items = @(); $collect = $false
        foreach ($ln in $lines) {
            if ($ln -match "^\s*$([regex]::Escape($key)):\s*$") { $collect = $true; continue }
            if ($collect) {
                if ($ln -match '^\s*-\s*(.+?)\s*$') { $items += $matches[1].Trim().Trim('"',"'") }
                elseif ($ln -match '^\S') { $collect = $false }
            }
        }
        return $items
    }

    if ($tool -eq 'Edit' -or $tool -eq 'Write') {
        $path = $in.tool_input.file_path
        if (-not $path) { Allow }
        $full = $path.Replace('\','/')
        if ($full.ToLower().StartsWith($root.ToLower())) { $rel = $full.Substring($root.Length).TrimStart('/') } else { $rel = $full }

        foreach ($frag in (Read-List 'protected_paths')) {
            $f = $frag.Replace('\','/')
            if ($f -and $rel -like "*$f*") {
                Block "SDLC guard: '$rel' is a protected path (matches '$frag' in .sdlc/config.yaml). A human must authorize this change, or make it through the proper SDLC stage."
            }
        }

        if (($lines | Where-Object { $_ -match '^\s*protect_tests_when_fixing:\s*true\s*$' }).Count -gt 0) {
            $tfLine = $lines | Where-Object { $_ -match '^\s*test_path_fragments:\s*\[(.+)\]' } | Select-Object -First 1
            if ($tfLine -and $tfLine -match '\[(.+)\]') {
                foreach ($t in ($matches[1] -split ',')) {
                    $t = $t.Trim().Trim('"',"'")
                    if ($t -and $rel -match [regex]::Escape($t)) {
                        Block "SDLC guard: '$rel' looks like a test file (matches '$t'). In bug-fix mode tests are protected so the agent can't edit them to pass. Write the failing test in the Build stage, then fix the code."
                    }
                }
            }
        }
        Allow
    }

    if ($tool -eq 'Bash') {
        $cmd = $in.tool_input.command
        if (-not $cmd) { Allow }
        if ($cmd -match 'SDLC_RELEASE_AUTH=') { Allow }   # named release authorization present
        foreach ($p in (Read-List 'prod_gate_command_patterns')) {
            if ($p -and $cmd -match $p) {
                Block "SDLC production gate: this command matches prod-gate pattern '$p'. The agent stops at the production gate. A release manager must authorize by prefixing the command with SDLC_RELEASE_AUTH=<ticket>; the decision is logged."
            }
        }
        Allow
    }
    Allow
}
catch {
    try { Add-Content -Path (Join-Path $env:USERPROFILE '.claude/sdlc-guard.log') -Value "$(Get-Date -Format o) ERROR $($_.Exception.Message)" } catch {}
    exit 0
}
