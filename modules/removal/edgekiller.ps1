$edgoogle = "$env:SYSTEMDRIVE\Program Files (x86)\Microsoft\Edge"
$edgedone = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").EdgeKilled
if ($edgoogle -eq $false -or $edgedone -eq 1) {exit}

$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Microsoft Edge Chromium terminator module"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "Microsoft Edge Chromium terminator module" -ForegroundColor Cyan -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}

Write-Host "Guarding the script from Microsoft Edge poping up during startup" -ForegroundColor Cyan -BackgroundColor DarkGray 
Write-Host "(If this window doesn't show any activity after a long while and you have confirmed that Edge isn't running, you can close it)"
Write-Host " "

while ($true) {
	$chedgeck = Get-Process msedge -ErrorAction SilentlyContinue
	$edgedone = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").EdgeKilled
	if ($chedgeck) {
		Write-Host "GOTCHA" -ForegroundColor Magenta
		taskkill /f /im msedge.exe
		Write-Host "Murder operation complete. Adiós" -ForegroundColor Green -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
		Start-Sleep -Seconds 5
		break
	} elseif ($edgedone -eq 1) {
		Write-Host "Looks like Edge is a good boy today. It didn't pop up. Exiting..." -ForegroundColor Yellow -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
		Start-Sleep -Seconds 5
		break
	}
	Start-Sleep -Seconds 3
}
