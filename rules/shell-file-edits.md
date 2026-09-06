# Shell File Edits (Windows / Git Bash)

This machine is Windows 11. The Bash tool is **Git Bash (MSYS2)**, the PowerShell tool is
**pwsh 7**. Their string syntaxes are mutually invalid. Files in this environment are
frequently CRLF. Every rule below was verified empirically on this machine.

## 1. Heredocs create files. They never edit files.

| Task | Use |
|------|-----|
| Create a brand-new file | `cat > f <<'EOF'` — quoted delimiter, always |
| Change lines in an existing file | **Edit tool.** Not sed, not python, not heredoc (see §4) |
| Append to an existing file | Edit tool, or check the file's line endings first |
| Rewrite a whole existing file | Write tool (after Read) |

A heredoc `>` on an existing file truncates it. Anything you did not retype is gone.
That is the single most common way a file gets "messed up".

## 2. Always quote the heredoc delimiter: `<<'EOF'`, never `<<EOF`

With an unquoted delimiter, bash expands the body before it reaches the file. Verified:

- `${NAME}` in a JS template literal → replaced with a shell variable's value
- `$(...)` anywhere in the content → **executed as a command**, output substituted
- `` `x` `` → executed
- `\` at end of line → line silently joined to the next
- `\d` in a regex → collapsed to `\d`

None of these error. They produce a plausible-looking, wrong file.

## 3. `sed -i` rewrites every line ending in the file

Verified on this machine: `sed -i 's/beta/BETA/'` against a CRLF file changed one line and
converted **all** `\r\n` → `\n`. The diff is the whole file. Reviewers cannot see the real
change. Never use `sed -i` on a file you have not confirmed is LF-only.

## 4. Never write a script to modify code or documentation

**Rule: do not use a python (or node, perl, awk) script to change existing code, config, or
docs.** Not to patch lines, not to bulk-rename, not to "fix all the imports at once", not to
regenerate a file in place. Use the Edit tool (targeted change) or the Write tool (full rewrite
after a Read). This holds regardless of how many files are involved — N Edit calls are cheaper
than one silent corruption.

Why it is banned, not merely discouraged: Python's default text mode translates on write.
Verified on this machine — reading an **LF-only** file with `readlines()` and writing it back
converted every line to CRLF, a whole-file diff. A line-index rewrite is not safer than `sed -i`;
it moves the corruption to the other direction and adds an off-by-one risk on top. The failure
is silent: the script exits 0 and the file looks fine until someone reads the diff.

**The only exception** — both halves required:

1. No editing tool can do the job (a genuinely mechanical transform across many files that Edit
   cannot express), **and**
2. You can show the script does not damage the file or its documentation.

Showing it means, before you accept the result:

```bash
file -- path                 # know the line endings going in
cp -r target target.bak      # backup first
# run the script, then:
git diff --stat -- target    # only the lines you meant to change?
diff target.bak/f target/f   # if not under git
```

If `--stat` shows every line changed, you converted line endings — restore the backup and use
Edit. If you cannot run that check, you do not have the exception: use Edit, or ask the user.

Reaching for a python line-rewrite script is itself the signal that the Edit tool was the right
call two steps ago.

Analysis scripts are unaffected — reading, parsing, counting, and reporting on files is fine.
The ban is on **writing**.

## 5. Do not cross the two shells' syntax

- Bash tool: heredocs work. PowerShell here-strings (`@'…'@`) and backtick continuation do not.
- PowerShell tool: `<<'EOF'` is a **parse error** ("Missing file specification after
  redirection operator"). Verified. PowerShell has no heredoc.

## 6. `<<-EOF` strips tabs only

Space-indented closing delimiters do not terminate the heredoc — the rest of the command is
swallowed as file content. If you indent a heredoc, the closer must be tab-indented.
Simplest fix: don't indent heredocs.

## 7. Auto mode does not override this

Auto mode asks for Bash-first file operations. Reading (`cat`, `sed -n`, `grep`, `find`) via
Bash is correct and safe. **Modifying an existing file is the case where "Bash genuinely
cannot do the job"** on this platform — take the Edit tool, and say why in one clause if it
seems worth noting.

## Pre-flight, when a shell-side write is genuinely unavoidable

```bash
file -- path            # check for "with CRLF line terminators"
cp path path.bak        # then diff against it afterwards
git diff --stat -- path # one file, few lines? or the whole file rewritten?
```

If `--stat` shows every line changed, you converted the line endings. Restore the backup.
