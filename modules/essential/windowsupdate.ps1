# This module needs a rework soon. 2 passes aren't enough, we need a target version and force to update until it reaches the goal. Can cause restart loops if WU is broken
$wureboot = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").RebootForWU

switch ($build) {
    {$_ -ge 10240 -and $_ -le 19041} {$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ReleaseId}
    {$_ -ge 19042 -and $_ -le 19044} {$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion}
}

Write-Host "Getting Windows ready" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
$wudir = (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate)
if ($wudir -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name 'WindowsUpdate'}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersionInfo' -Value $version -Type String -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersion' -Value 1 -Type DWord -Force
Restart-Service -Name wuauserv
Write-Host -ForegroundColor Cyan "In two passes and four update checks, install as many updates found as possible"
# So I tried to use Get-WUList instead of Get-WindowsUpdates to declutter the console window. Well it worked when ran as a command in PowerShell, but not in the script??? (it's still showing detailed info about updates instead of a list)
if ($wureboot -eq 0 -or $null -eq $wureboot) {
	Write-Host "Checking for updates for the first time"; Get-WUList
    Write-Host "Checking for updates for the second time and installing all of them"; Get-WUList -AcceptAll -Install -NotCategory 'Upgrade' -IgnoreReboot
    Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootForWU" -Value 1 -Type DWord -Force
    Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Restarting to finish installing updates (Pass 1/2)" -n; Write-Host ([char]0xA0)
	& $PSScriptRoot\..\..\core\resume.ps1
    shutdown -r -t 5 -c "BioniDKU needs to restart your PC to finish installing updates"
    Start-Sleep -Seconds 30
	exit
}
if ($wureboot -eq 1) {
    Write-Host "Checking for updates for the third time"; Get-WUList
    Write-Host "Checking for updates for the last time and installing all of them"; Get-WUList -AcceptAll -Install -NotCategory 'Upgrade' -IgnoreReboot
    Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootForWU" -Value 2 -Type DWord -Force
    Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Restarting to finish installing updates (Pass 2/2)" -n; Write-Host ([char]0xA0)
	& $PSScriptRoot\..\..\core\resume.ps1
    shutdown -r -t 5 -c "BioniDKU needs to restart your PC to finish installing updates"
    Start-Sleep -Seconds 30
	exit
}
if ($wureboot -eq 2) {
    Write-Host "Updates are installed." -ForegroundColor Green; Write-Host '(Though they might not be the latest updates. You can use PSWindowsUpdate to get the latest ones after finishing the script, but remember to reenable "Windows Update service" and "Windows Modules Installer" if you have disabled them)'
}