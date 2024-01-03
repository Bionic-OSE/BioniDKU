Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "EdgeKilled" -Value 1 -Type DWord -Force
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Let's get manually-only things out of the way!"
Write-Host " "

Write-Host -ForegroundColor Cyan "First, Explorer stuffs."
Write-Host -ForegroundColor Yellow "1. Open File Explorer, it should take you straight to This PC. There:"
Write-Host -ForegroundColor White " - Set the view to details, close Explorer and reopen it several times to make sure the setting is saved."; Write-Host "   (Explorer has Alzheimer's and will reset the view if you only open it once)."
Write-Host -ForegroundColor Yellow "2. Then, go to Settings and disable the following items on the taskbar if they (*exist and) are enabled:"
Write-Host "   (Please also check in Taskbar Settings since some icons might not be shown at this moment, make sure Windows is"; Write-Host "   activated tho)."
if ($build -le 10586) {Write-Host "   (NOTE: On this build, system tray icons settings are located in `"System > Notifications & actions!`""}
Write-Host -ForegroundColor White " - Input indicator"
Write-Host -ForegroundColor White " - Touch Keyboard"
Write-Host -ForegroundColor White " - Location icon"
if ($essentialapps -eq $true) {
	Write-Host -ForegroundColor White " - Network icon"
}
if ($build -ge 18362) {
	Write-Host -ForegroundColor White " - Microphone icon"
	Write-Host -ForegroundColor White " - Meet now icon*"
}
if ($build -ge 18363) {
	Write-Host -ForegroundColor White " - News and interests*"
}
Write-Host -ForegroundColor Yellow "3. While still in Settings:"
if ($firefox -eq 1) {Write-Host -ForegroundColor White " - Change the default browser to Firefox (and of course, ignore Windows' beg for Edge)."
if ($keepedgechromium) {Write-Host "   (If you chose to keep Edge Chromium and want that instead, skip this step if it's already the default)"}}
if ($sltoshutdownwall) {Write-Host -ForegroundColor White ' - Head over to Lock screen Settings and switch the background type to "Picture".'}
Write-Host -ForegroundColor White " - Try your best to turn all kinds of notifications off"
if ($balloonnotifs) {Write-Host "   (Don't worry, it won't affect ballon notifications)"}
Write-Host -ForegroundColor Yellow "4. Finally, unpin everything else except File Explorer (this means DO NOT unpin Explorer!)."
Write-Host -ForegroundColor Cyan "Press Enter once you have done with those."
Read-Host

Write-Host " "
# This part needs some redesigning
Write-Host -ForegroundColor Cyan "Secondly, disabling Windows Update."
if ($build -eq 10240 -and -not $dotnet462) {
	Write-Host -ForegroundColor Yellow "Nevermind, Wu10Man does not work without .NET 4.6.2. Disabling it the classic way..."
	Stop-Service -Name wuauserv -ErrorAction SilentlyContinue
	Start-Process sc.exe -Wait -NoNewWindow -ArgumentList "delete wuauserv"
	Write-Host "Alright, that's gonna be all for the manually-done series."
} else {
	if ($build -eq 10240) {$net = "461"} else {$net = "471"}
	Expand-Archive -Path $datadir\utils\Wu10Man$net.zip -DestinationPath $datadir\utils\Wu10Man
	Start-Process $datadir\utils\Wu10Man\Wu10Man.exe -WorkingDirectory $datadir\utils\Wu10Man
	Write-Host 'In order to completely disable Windows Update, a program called "Wu10Man" will soon appear on your screen.'
	Write-Host -ForegroundColor Black -BackgroundColor Cyan "FOLLOW THESE STEPS CLOSELY once it's opened:"
	Write-Host -ForegroundColor Yellow ' - You are now in the "Windows Services" tab. Click "Disable All Services" and wait for it to complete.'
	if ($build -ge 18362) {
		Write-Host -ForegroundColor Yellow ' - Now go to the Settings app > Windows Update and click Pause Updates (ignore this and the next step if the button is grayed out, you are out of luck).'
		Write-Host -ForegroundColor Yellow ' - Then, come back to Wu10Man and come over to the "Pause updates" tab, type your desired pause limit date in mm/dd/yyyy into both fields (I would recommend around 10 years from now), and click Save.'
	}
	if ($net -eq "471") {Write-Host -ForegroundColor Yellow ' - Then, in the "BETA - Scheduled Tasks" tab, click "Disable All Tasks" and wait for it to complete.'} else {Write-Host -ForegroundColor DarkGray '   (There was supposed to be a "Scheduled Tasks" tab, but this version which RTM can only run does not have it).'}
	Write-Host -ForegroundColor White 'If any tasks appears to freeze for too long, close or kill the program, reopen it, and disable the items one by one.'
	Write-Host " "
	
	Write-Host "That will be the last step of the manually-done series."
}

Write-Host -ForegroundColor Cyan "Once you press Enter, everything else should be automated!"
if ($build -eq 10240) {Get-ScheduledTask -TaskPath '\Microsoft\Windows\WindowsUpdate\' -TaskName '*' | Unregister-ScheduledTask -Confirm:$false}
Read-Host
