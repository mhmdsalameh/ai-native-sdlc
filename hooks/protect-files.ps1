# PreToolUse (Edit|Write) - block edits to sensitive files, in ANY project.
# Docs pattern: PreToolUse deny via JSON (exit 0 + hookSpecificOutput.permissionDecision=deny).
# Fail-open: any error -> allow, so a global guard can never brick editing.
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
    $path = $in.tool_input.file_path; if (-not $path) { Allow }
    $p    = $path.Replace('\','/')
    $leaf = ($p -split '/')[-1]

    # .env family - allow example/template variants, block real ones (.env, .env.local, .env.prod, ...)
    if ($leaf -match '^\.env($|\.)') {
        if ($leaf -notmatch '^\.env\.(example|sample|template|dist|defaults)$') {
            Deny "protect-files: '$leaf' is an environment/secrets file. If a change is truly needed, ask the user to make it."
        }
    }

    # git internals / credential stores
    if ($p -match '(^|/)\.git/')             { Deny "protect-files: '$p' is inside .git/ - never edit git internals directly." }
    if ($p -match '(^|/)\.ssh/')             { Deny "protect-files: '$p' is under .ssh/ (keys/config)." }
    if ($p -match '(^|/)\.aws/credentials$') { Deny "protect-files: '$p' holds AWS credentials." }
    if ($p -match '(^|/)\.npmrc$')           { Deny "protect-files: '$p' can hold auth tokens." }

    # lockfiles - regenerate with the package manager, don't hand-edit
    $locks = @('package-lock.json','yarn.lock','pnpm-lock.yaml','npm-shrinkwrap.json',
               'composer.lock','Gemfile.lock','Cargo.lock','poetry.lock','Pipfile.lock')
    if ($locks -contains $leaf) {
        Deny "protect-files: '$leaf' is a lockfile - regenerate it with the package manager, don't edit it by hand."
    }

    # private key material
    if ($leaf -match '\.(pem|key|p12|pfx|keystore|jks)$' -or
        $leaf -match '(^|_)id_(rsa|dsa|ecdsa|ed25519)') {
        Deny "protect-files: '$leaf' looks like private key material."
    }

    Allow
}
catch {
    try {
        $d = Join-Path $env:USERPROFILE '.claude/logs'
        if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force $d | Out-Null }
        Add-Content (Join-Path $d 'hooks-error.log') "$(Get-Date -Format o) protect-files ERROR $($_.Exception.Message)"
    } catch {}
    exit 0
}
