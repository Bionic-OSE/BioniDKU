
Write-Host "NOTICE: Due to the script's limited ability, the following stuffs might have not been setup properly as planned:" -ForegroundColor Yellow -BackgroundColor DarkGray -n; Write-Host ([char]0xA0) -BackgroundColor Black

if ($build -eq 10240) {
	Write-Host "- The Lock screen might not be disabled. If that's the case, " -n; Write-Host -ForegroundColor Yellow 'please use Winaero Tweaker to disable it instead.'
if ($build -le 17763) {
	Write-Host "- The File Explorer icon might not get replaced with the 1903 one. In that case, " -n; Write-Host -ForegroundColor Yellow 'open an Administrator CMD and run "ie4uinit -show" several times until it displays the correct icon.'
}
if ($build -ge 17763) {
	Write-Host "- The Chromium Edge icon might not get deleted from the desktop. In that case just delete it."
}
Write-Host "If you do find more stuffs, please do them manually and report back to me. I will look into it and see if it's possible to get fixed."
Write-Host -ForegroundColor Yellow "And remember to check if you have done all of the manually-done stuffs! Some of you might have read the instructions too fast and forgot to follow them. In that case, scroll this console up near the top to find the instructions again. " -n; Write-Host -ForegroundColor Red "DO NOT REPORT THESE STUFFS AS BUGS! YOU ARE IN CHARGE OF THEM!"
