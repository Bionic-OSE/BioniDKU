# BioniDKU end-of-script message file - The note message that gets printed at the end of script execution - (c) Bionic Butter

Param(
  [Parameter(Mandatory=$True,Position=0)]
  [int32]$state
)

switch ($state) {
	0 {Write-Host "`r`nHowever, just a little note if you are to do that now..." -ForegroundColor Yellow}
	1 {
		Show-WindowTitle 4
		Show-Branding clear
		Write-Host "The script has completed all operations and has restarted the device for you." -ForegroundColor Black -BackgroundColor Green
		Write-Host "This IDKU has been fully set up." -ForegroundColor Green -n; Write-Host " However...`r`n" -ForegroundColor Yellow
	}
}
Write-Host "Due to the script's limited ability, the following stuffs might have not been setup properly as planned:" -ForegroundColor Yellow -BackgroundColor DarkGray

Write-Host " - The Lock screen might not be disabled. If that's the case, " -n; Write-Host -ForegroundColor Yellow 'please use Winaero Tweaker to disable it instead.'
switch ($build) {
	default {}
	{$_ -eq 14393 -or $_ -eq 16299} {
		Write-Host " - Windows Defender tray icon might not get removed. In that case, " -n; Write-Host -ForegroundColor Yellow 'please disable it in Task Manager > Startup tab, or use Winaero Tweaker.'
	}
	{$_ -le 17763} {
		Write-Host " - The File Explorer icon might not get replaced with the 1903 one. In that case, " -n; Write-Host -ForegroundColor Yellow 'open an Administrator CMD and run "ie4uinit -show" several times until it displays the correct icon.'
	}
	{$_ -ge 18362} {
		Write-Host " - If you got errors related to ContextMenuNormalizer from earlier, " -n; Write-Host -ForegroundColor Yellow 'please install the required Visual C++ Runtime(s) to address the issue.'
	}
}

Write-Host "If you do find more stuffs or problems, please do or fix them manually and report back to me. I appreciate all feedbacks!`r`n" -ForegroundColor White
switch ($state) {
	0 {Show-Branding}
	1 {Write-Host "Press Enter to exit." -ForegroundColor White}
}
Write-Host "Made by Bionic Butter with Love <3" -ForegroundColor Black -BackgroundColor Magenta
Read-Host
