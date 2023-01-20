# This module is getting deprecated soon, in flavor of PENetwork Manager.

Write-Host "1903 Network Icon Replacement" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)

Stop-Process -Name "explorer" -Force
takeown /f C:\windows\system32\pnidui.dll
icacls C:\windows\system32\pnidui.dll /grant Administrators:F
Rename-Item -Path C:\windows\system32\pnidui.dll -NewName pnidui.dll.backup
Copy-Item -Path $workdir\utils\pnidui.dll -Destination 'C:\Windows\system32\pnidui.dll' -Force
Start-Sleep -Seconds 5
Start-Process "C:\Windows\explorer.exe"