# This is the note message that gets printed at the end of script execution

Write-Host "But before you do that..." -ForegroundColor Yellow
Write-Host "Due to the script's limited ability, the following stuffs might have not been setup properly as planned:" -ForegroundColor Yellow -BackgroundColor DarkGray

switch ($build) {
	default {}
	{$_ -ge 10240} {
		Write-Host "- Toast Notification won't be disabled completely " -n; Write-Host -ForegroundColor Yellow "until you turn on Focus Assist (Do Not Distrub) in Settings, without exceptions (Alarms only and uncheck all checkboxes)."
		Write-Host "- The Lock screen might not be disabled. If that's the case, " -n; Write-Host -ForegroundColor Yellow 'please use Winaero Tweaker to disable it instead.'
	}
	{$_ -le 15063} {
		Write-Host "- HomeGroup might not be removed in Explorer (and won't be removed for most cases, due to how hard it is to remove automatically). In that case, " -n; Write-Host -ForegroundColor Yellow 'please right click the item in the side pane and delete it.'
	}
	{$_ -eq 15063 -or $_ -eq 16299} {
		Write-Host "- Windows Defender tray icon might not get removed. In that case, " -n; Write-Host -ForegroundColor Yellow 'please disable it in Task Manager > Startup tab, or use Winaero Tweaker.'
	}
	{$_ -le 17763} {
		Write-Host "- The File Explorer icon might not get replaced with the 1903 one. In that case, " -n; Write-Host -ForegroundColor Yellow 'open an Administrator CMD and run "ie4uinit -show" several times until it displays the correct icon.'
	}
}

Write-Host "If you do find more stuffs or problems, please do or fix them manually and report back to me. I appreciate all feedbacks!" -ForegroundColor White
