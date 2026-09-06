# PostToolUse(Edit|Write): record edited files so /codemap knows what went stale.
# Must live in a script file, not an inline -Command string: Claude Code runs hooks
# through sh, which would expand every $var away before PowerShell sees it.
try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }

    $fp = ($raw | ConvertFrom-Json).tool_input.file_path
    if (-not $fp) { exit 0 }
    if ($fp -match 'CODEMAP\.md$|DEPMAP\.md$|\.codemap-dirty$') { exit 0 }

    $root = (Get-Location).Path
    if (Test-Path (Join-Path $root 'CODEMAP.md')) {
        Add-Content -Path (Join-Path $root '.codemap-dirty') -Value $fp -Encoding utf8
    }
} catch {
}
exit 0
