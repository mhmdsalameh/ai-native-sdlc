# Notification - desktop alert when Claude Code needs input. Runs async; non-blocking.
# Uses a NotifyIcon balloon (auto-dismisses) rather than a blocking MessageBox dialog.
try {
    $raw = [Console]::In.ReadToEnd()
    $detail = 'needs your attention'
    if ($raw) { try { $in = $raw | ConvertFrom-Json; if ($in.notification_type) { $detail = $in.notification_type } } catch {} }

    Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
    Add-Type -AssemblyName System.Drawing -ErrorAction SilentlyContinue

    $ni = New-Object System.Windows.Forms.NotifyIcon
    $ni.Icon = [System.Drawing.SystemIcons]::Information
    $ni.Visible = $true
    $ni.BalloonTipTitle = 'Claude Code'
    $ni.BalloonTipText  = "Claude Code $detail"
    $ni.ShowBalloonTip(5000)
    Start-Sleep -Milliseconds 6000
    $ni.Dispose()
} catch {}
exit 0
