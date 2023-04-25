Write-Host "Installing .NET 4.6.2" -ForegroundColor Cyan -BackgroundColor DarkGray
reg add HKCU\Software\AutoIDKU /v dotnetrebooted /t REG_DWORD /d 0x1
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
& $coredir\kernel\hikaru.ps1
Write-Host " "
Write-Host -ForegroundColor Yellow "Until .NET finishes the installation and automatically restarts the system, please DO NOT:"
Write-Host -ForegroundColor Yellow "- Try to stop the installation process"
Write-Host -ForegroundColor Yellow "- Restart the computer manually (unless if it doesn't do so automatically)"
Write-Host -ForegroundColor Yellow "- Restart Explorer (it won't come back if you do so)"
Start-Process $workdir\dls\dotnet462.exe -NoNewWindow -Wait -ArgumentList "/passive /log %temp%\net.htm"
Start-Sleep -Seconds 30
