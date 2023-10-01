Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Enable old battery flyout"
# Set this regardless if the system has a battery or not.
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Name 'UseWin32BatteryFlyout' -Value 1 -Type DWord -Force
