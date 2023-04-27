$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Windows Update suspender module"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue -n; Write-Host ([char]0xA0)
	Write-Host "Windows Update suspender module" -ForegroundColor Blue -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}

Show-Branding
Write-Host "Preventing Windows Update from doing extra things while a manual update is downloading" -ForegroundColor Cyan -BackgroundColor DarkGray
Write-Host " "

while ($true) {
	Stop-Process -Name "TiFileFetcher" -Force -ErrorAction SilentlyContinue
	Stop-Process -Name "TiWorker" -Force -ErrorAction SilentlyContinue
	Stop-Process -Name "wusa" -Force -ErrorAction SilentlyContinue
	Stop-Process -Name "qualauncher" -Force -ErrorAction SilentlyContinue
	Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
	Start-Sleep -Seconds 3
	$killstop = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).WuKillerStop
	if ($killstop -eq 1) {exit}
}
