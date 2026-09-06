# PostToolUse (Edit|Write) - format the edited file with a language-appropriate formatter,
# ONLY if that formatter is on PATH. No-op in any project that doesn't have the tool, so it is
# safe globally. Runs async; never blocks. Best-effort (all errors swallowed).
try {
    $raw = [Console]::In.ReadToEnd(); if (-not $raw) { exit 0 }
    $in  = $raw | ConvertFrom-Json
    $path = $in.tool_input.file_path; if (-not $path) { exit 0 }
    if (-not (Test-Path $path)) { exit 0 }

    function Have($n) { [bool](Get-Command $n -ErrorAction SilentlyContinue) }
    $ext = [System.IO.Path]::GetExtension($path).ToLower()

    switch -regex ($ext) {
        '^\.(js|jsx|ts|tsx|mjs|cjs|json|jsonc|css|scss|less|html|md|mdx|yaml|yml|vue|svelte)$' {
            if     (Have 'prettier') { & prettier --write --log-level silent -- "$path" 2>$null }
            elseif (Have 'npx')      { & npx --no-install prettier --write --log-level silent -- "$path" 2>$null }
        }
        '^\.py$'  { if (Have 'black') { & black -q -- "$path" 2>$null } elseif (Have 'ruff') { & ruff format -- "$path" 2>$null } }
        '^\.go$'  { if (Have 'gofmt') { & gofmt -w -- "$path" 2>$null } }
        '^\.rs$'  { if (Have 'rustfmt') { & rustfmt --quiet -- "$path" 2>$null } }
        '^\.rb$'  { if (Have 'rubocop') { & rubocop -A -f quiet -- "$path" 2>$null } }
        '^\.(sh|bash)$' { if (Have 'shfmt') { & shfmt -w -- "$path" 2>$null } }
    }
} catch {}
exit 0
