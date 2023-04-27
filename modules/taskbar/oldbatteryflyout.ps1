Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Enable old battery flyout"
if ($null -ne $battery) {Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Name 'UseWin32BatteryFlyout' -Value 1 -Type DWord -Force}
