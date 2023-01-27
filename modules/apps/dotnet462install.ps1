$workdir = "$PSScriptRoot\..\.."

$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter and Sunryze | .NET 4.6.2 installation waiter module"
function Show-Branding { # Has to declare it here again because of a different PowerShell process
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host ".NET 4.6.2 installation waiter module" -ForegroundColor Cyan -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}

Show-Branding
Write-Host -ForegroundColor Yellow "Follow the installer's instructions. Then when it tells you to restart, press Restart Later, come back here and press Enter. " -n; Write-Host -ForegroundColor Black -BackgroundColor Yellow "DO NOT PRESS RESTART NOW!"
Start-Process $workdir\dotnet462.exe -NoNewWindow
Read-Host
reg add HKCU\Software\AutoIDKU /v dotnetrebooted /t REG_DWORD /d 0x1
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
& $PSScriptRoot\hikaru.ps1
Write-Host "Now restarting..."
shutdown -r -t 5 -c "BioniDKU needs to restart your PC to finish installing .NET 4.6.2"
Start-Sleep -Seconds 30
