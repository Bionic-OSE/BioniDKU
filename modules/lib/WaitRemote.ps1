$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Startup interrupter"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta
	Write-Host "Startup interrupter" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}

Write-Host "Waiting 30 seconds for you to connect via your remote desktop solution." -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
Write-Host "Once you have connected, you can press CTRL+C to continue." -ForegroundColor Black -BackgroundColor Cyan -n; Write-Host ([char]0xA0)
for ($wt = 30; $wt -ge 1; $wt--) {
	$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Startup interrupter - $wt seconds remaining..."
	Start-Sleep -Seconds 1
}
