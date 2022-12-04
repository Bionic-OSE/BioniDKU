Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting Explorer to open on This PC" -n; Write-Host ([char]0xA0)
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Value 1 -Type DWord -Force
Start-Sleep -Seconds 1
Stop-Process -Name "explorer"
Start-Sleep -Seconds 1
Start-Process "explorer.exe"