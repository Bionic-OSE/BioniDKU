# This module does NOT remove Microsoft Edge Chromium, but rather terminate the task on shell startup

$global:workdir = Split-Path(Split-Path "$PSScriptRoot")
$global:datadir = "$workdir\data"
$edgoogle = Test-Path "$env:SYSTEMDRIVE\Program Files (x86)\Microsoft\Edge"
$edgedone = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").EdgeKilled
if ($edgoogle -eq $false -or $edgedone -eq 1) {exit}
Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Ambient.psm1

$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Microsoft Edge Chromium terminator module"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Microsoft Edge Chromium terminator module" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}

Show-Branding
Write-Host "Guarding the script from Microsoft Edge poping up during startup" -ForegroundColor Cyan -BackgroundColor DarkGray 
Write-Host "(If this window doesn't show any activity after a long while and you have confirmed that Edge isn't running, you can close it)"
Write-Host " "

while ($true) {
	$chedgeck = Get-Process msedge -ErrorAction SilentlyContinue
	$edgedone = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").EdgeKilled
	if ($chedgeck) {
		Write-Host "GOTCHA" -ForegroundColor Magenta
		taskkill /f /im msedge.exe
		Play-Ambient 7
		Write-Host "Murder operation complete. Adios" -ForegroundColor Green -BackgroundColor DarkGray
		Start-Sleep -Seconds 5
		break
	} elseif ($edgedone -eq 1) {
		Write-Host "Looks like Edge is a good boy today. It didn't pop up. Exiting..." -ForegroundColor Yellow -BackgroundColor DarkGray
		Start-Sleep -Seconds 5
		break
	}
	Start-Sleep -Seconds 3
}
