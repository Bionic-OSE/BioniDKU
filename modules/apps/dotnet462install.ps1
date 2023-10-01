Write-Host "Installing .NET 4.6.2" -ForegroundColor Cyan -BackgroundColor DarkGray
Write-Host " "
Write-Host -ForegroundColor Yellow "Until .NET finishes the installation and automatically restarts the system, please DO NOT:"
Write-Host -ForegroundColor Yellow "- Try to stop the installation process"
Write-Host -ForegroundColor Yellow "- Restart the computer manually (unless if it doesn't do so automatically)"
Start-Process $datadir\dls\dotnet462.exe -NoNewWindow -Wait -ArgumentList "/passive /log %temp%\net.htm"
Start-Sleep -Seconds 30
Read-Host
