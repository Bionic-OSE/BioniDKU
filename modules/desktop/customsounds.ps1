# BioniDKU custom sounds installer module

$global:workdir = Split-Path(Split-Path "$PSScriptRoot")
$global:datadir = "$workdir\data"
Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Support.psm1
Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Destructor.psm1

$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Custom sound installer module"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Custom sound installer module" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}
Start-Logging NormalMode_CustomSounds
Show-Branding

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing Custom system sounds"

Write-Host -ForegroundColor Cyan "Removing old system sounds until all files are gone, starting in 3 seconds"
while ($true) {
	Start-Sleep -Seconds 3
	$testmedia = (Test-Path -Path "$env:SYSTEMDRIVE\Windows\Media\*")
	if ($testmedia) {Remove-SystemFile D $env:SYSTEMDRIVE\Windows\Media} else {break}
}

Write-Host -ForegroundColor Cyan "Old sounds have been removed, now placing new sounds"
Start-Sleep -Seconds 1
$media10074 = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Media10074
if ($media10074 -eq 1) {$var = "1k74"} else {$var = "9200"}
New-Item -Path "$env:SYSTEMDRIVE\Windows" -Name "Media" -ItemType directory -ErrorAction SilentlyContinue
Start-Process icacls -Wait -NoNewWindow -ArgumentList "$env:SYSTEMDRIVE\Windows\Media /grant Everyone:(OI)(CI)F /t /inheritance:r"
Expand-Archive -Path $datadir\utils\Media${var}.zip -DestinationPath $env:SYSTEMDRIVE\Windows\Media
Copy-Item -Path $datadir\utils\* -Include Media*.zip -Destination $env:SYSTEMDRIVE\Windows
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Custom system sounds have been installed"
Start-Sleep -Seconds 3
