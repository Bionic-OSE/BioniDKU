Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Replacing Segoe UI Emoji Font with the one from Windows 11 build 22563"
Copy-Item -Path $workdir\utils\seguiemj22563.ttf -Destination C:\Windows\Fonts\seguiemj22563.ttf
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Segoe UI Emoji (TrueType)" -Value "seguiemj22563.ttf" -Type String -Force
