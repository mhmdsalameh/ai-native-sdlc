# SessionStart (matcher: compact) - re-inject key context after compaction.
# stdout on SessionStart is added to Claude's context. Kept short; normal startup relies on CLAUDE.md.
$lines = @(
    'Context reminder (post-compaction):',
    '- This setup follows the AI-native SDLC. Run /sdlc for the stage map; artifacts: intent.md -> spec.md -> plan.md.',
    '- Before continuing, re-read CLAUDE.md, STATE.md, and CODEMAP.md in the working repo (conventions, verified facts, code map).',
    '- Windows file edits: use Edit/Write tools, never sed -i or scripted rewrites (~/.claude/rules/shell-file-edits.md).'
)
try {
    $log = & git log --oneline -5 2>$null
    if ($log) { $lines += '- Recent commits:'; foreach ($l in $log) { $lines += "    $l" } }
} catch {}
$lines -join "`n"
exit 0
