Write-Host "Downloading .NET 4.6.2" -ForegroundColor Cyan -BackgroundColor DarkGray
Write-Host "If it fails to download, please manually download via this link:"  -BackgroundColor Cyan -ForegroundColor Black 
Write-Host "https://go.microsoft.com/fwlink/?LinkId=780600" -ForegroundColor Cyan
$462dl = "https://download.visualstudio.microsoft.com/download/pr/8e396c75-4d0d-41d3-aea8-848babc2736a/80b431456d8866ebe053eb8b81a168b3/ndp462-kb3151800-x86-x64-allos-enu.exe"
Start-BitsTransfer -Source $462dl -Destination $workdir\dotnet462.exe
Start-Sleep -Seconds 2
Write-Host "Installing .NET 4.6.2" -ForegroundColor Cyan -BackgroundColor DarkGray
reg add HKCU\Software\AutoIDKU /v dotnetrebooted /t REG_DWORD /d 0x1
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
& $workdir\core\hikaru.ps1
Write-Host " "
Write-Host -ForegroundColor Yellow "Until .NET finishes the installation and automatically restarts the system, please DO NOT:"
Write-Host -ForegroundColor Yellow "- Try to stop the installation process"
Write-Host -ForegroundColor Yellow "- Restart the computer manually (unless if it doesn't do so automatically"
Write-Host -ForegroundColor Yellow "- Restart Explorer (it won't come back if you do so)"
Start-Process $workdir\dotnet462.exe -NoNewWindow -Wait -ArgumentList "/passive /log %temp%\net.htm"
Start-Sleep -Seconds 30
