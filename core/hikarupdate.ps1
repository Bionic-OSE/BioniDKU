$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter and Sunryze | Windows Update mode"
$butter = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Butter
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "Windows Update mode" -ForegroundColor Cyan -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
#& $PSScriptRoot\..\modules\essential\cWUngus.ps1
$workdir = "$PSScriptRoot\.."
Show-Branding
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Initializing components" -n; Write-Host ([char]0xA0)

$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
$buubr = "$build.$ubr"
Write-Host "You're running Windows 10 build $buubr"

$latest = "14393.2214","15063.1418","16299.1087","17134.1184","17763.1577","18362.1256","18363.1556"
if ($latest.Contains($buubr)) {
	Write-Host "The latest updates have been installed." -ForegroundColor Green -BackgroundColor DarkGray -n; Write-Host " Leaving Windows Update mode..."
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 1 -Type DWord -Force
	Start-Sleep -Seconds 5
	exit
}

# And here goes the main part, the update script

$hkau = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic
if ($hkau -eq 1) {
	$workdir = "$PSScriptRoot\.."
	Start-Process powershell -Wait -ArgumentList "-Command $workdir\music\musicn.ps1" -WorkingDirectory $workdir\music
	Start-Process pwsh -ArgumentList "-WindowStyle Hidden -Command $workdir\modules\essential\setupmusic.ps1"
}

Write-Host "Starting WinXShell" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ", a lightweight desktop environment used in Windows Preinstalled Environments (Windows PE)"
$hkws = Test-Path -Path "$env:SYSTEMDRIVE\Bionic\WinXShell"
if ($hkws -eq $false) {
	Expand-Archive -Path $workdir\utils\WinXShell.zip -DestinationPath $env:SYSTEMDRIVE\Bionic\WinXShell
}
Start-Process "$env:SYSTEMDRIVE\Bionic\WinXShell\WinXShell.exe"
Write-Host "If you see an error about OneDrive popping up, don't mind it, it will go away soon."
Start-Sleep -Seconds 5
taskkill /f /im OneDrive.exe

Write-Host "Getting Windows ready" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
Import-Module PSWindowsUpdate -Verbose
Import-Module BitsTransfer -Verbose
switch ($build) {
    {$_ -ge 10240 -and $_ -le 19041} {$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ReleaseId}
    {$_ -ge 19042 -and $_ -le 19044} {$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion}
}
$wudir = (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate)
if ($wudir -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name 'WindowsUpdate'}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersionInfo' -Value $version -Type String -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersion' -Value 1 -Type DWord -Force

Write-Host " "
Write-Host -ForegroundColor Cyan "Updating the system until it reaches the desired UBR"
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Hikancel" -Value 1 -Type DWord -Force
Start-Process pwsh -Wait -ArgumentList "-Command $PSScriptRoot\hikancel.ps1"
$hkc = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Hikancel
if ($hkc -eq 1) {
	Write-Host "You have aborted updates." -ForegroundColor Yellow -BackgroundColor DarkGray -n; Write-Host " Leaving Windows Update mode..."
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 1 -Type DWord -Force
	Start-Sleep -Seconds 5
	taskkill /f /im WinXShell.exe
	exit
}
Restart-Service -Name wuauserv
Write-Host "Checking for updates"; Get-WUList
Write-Host "Checking for updates again and installing all updates found"; Get-WUList -AcceptAll -Install -NotCategory 'Upgrade' -IgnoreReboot

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Restarting to finish installing updates" -n; Write-Host ([char]0xA0)
Start-Sleep -Seconds 5
shutdown -r -t 0
Start-Sleep -Seconds 30
exit