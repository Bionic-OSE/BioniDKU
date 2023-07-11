Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Replacing Segoe UI Emoji Font with the one from Windows 11 build 23475"
Copy-Item -Path $workdir\utils\seguiemj11.ttf -Destination C:\Windows\Fonts\seguiemj11.ttf
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Segoe UI Emoji (TrueType)" -Value "seguiemj11.ttf" -Type String -Force
