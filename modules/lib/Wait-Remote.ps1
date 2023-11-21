$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Startup delayer"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Startup delayer" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}

Show-Branding
Write-Host "Waiting 30 seconds for you to connect via your remote desktop solution." -ForegroundColor Cyan -BackgroundColor DarkGray
Write-Host "Once you have connected, you can press CTRL+C to continue." -ForegroundColor Black -BackgroundColor Cyan
for ($wt = 30; $wt -ge 1; $wt--) {
	$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Startup delayer | $wt seconds remaining..."
	Start-Sleep -Seconds 1
}
