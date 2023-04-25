Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "EdgeKilled" -Value 1 -Type DWord -Force
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Let's get manually-only things out of the way!" -n; Write-Host ([char]0xA0)
Write-Host " " -n; Write-Host ([char]0xA0)

Write-Host -ForegroundColor Cyan "First, Explorer stuffs."
Write-Host -ForegroundColor Yellow "1. Set the view in This PC to details, close it and reopen This PC several times to make sure the setting is saved."; Write-Host "   (Explorer has Alzheimer's and will reset the view if you only open This PC once)."
Write-Host -ForegroundColor Yellow "2. Then, disable the following items on the taskbar if they (*exist and) are enabled:"
Write-Host "   (Please also check in Taskbar Settings since some icons might not be shown at this moment, make sure Windows is"; Write-Host "   activated tho)."
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
Write-Host -ForegroundColor Yellow '3. While still in Settings, head over to Lock screen Settings and switch the background type to "Picture"'
Write-Host -ForegroundColor Yellow "4. Then, try your best to turn on Focus Assist (Do Not Distrub), and leave no exceptions (Alarms only and uncheck all checkboxes)"
Write-Host -ForegroundColor Yellow "5. Finally, unpin Microsoft Edge and/or any other UWP apps present, and leave File Explorer pinned."
Write-Host -ForegroundColor Cyan "Press Enter once you have done with those."
Read-Host

Write-Host " "
# This part needs some redesigning
Write-Host -ForegroundColor Cyan "Secondly, disabling Windows Update."
if ($build -ge 10586) {
	Expand-Archive -Path $workdir\utils\Wu10Man.zip -DestinationPath $workdir\utils\Wu10Man
	Start-Process $workdir\utils\Wu10Man\Wu10Man.exe -WorkingDirectory $workdir\utils\Wu10Man
	Write-Host 'In order to completely disable Windows Update, a program called "Wu10Man" will soon appear on your screen.'
	Write-Host -ForegroundColor Black -BackgroundColor Cyan "FOLLOW THESE STEPS CLOSELY once it's opened:" -n; Write-Host ([char]0xA0)
	Write-Host -ForegroundColor Yellow '- You are now in the first tab: "Windows Services". Click "Disable All Services" and wait for it to complete.'
	if ($build -ge 18362) {
		Write-Host -ForegroundColor Yellow '- Now go to the Settings app > Windows Update and click Pause Updates (ignore this and the next step if the button is grayed out, you are out of luck).'
		Write-Host -ForegroundColor Yellow '- Then, come back to Wu10Man and come over to the second tab: "Pause updates" and type your desired pause limit date in mm/dd/yyyy into both fields (I would recommend around 10 years from now XD). Then click Save and move on.'
	}
	Write-Host -ForegroundColor Yellow '- Then, in the last tab: "BETA - Scheduled Tasks". Click "Disable All Tasks" and wait for it to complete.'
	Write-Host -ForegroundColor White 'For the first and last tabs, if it appears to freeze for too long, close or kill the program, reopen it, and disable the items one by one.'
	#Write-Host -ForegroundColor Black -BackgroundColor Yellow "If you don't see any program coming up or an error pops up, go to $workdir\utils\Wu10Man and try to open Wu10Man.exe manually. Wait for a while, and if it still doesn't launch, report back to me and kill it in Task manager, then find a different way to delete Windows Update online." -n; Write-Host ([char]0xA0) -BackgroundColor Black
	Write-Host " "
	
	Write-Host "That will be the last step of the manually-done series."
}
else {
	Write-Host -ForegroundColor Yellow "Nevermind, Wu10Man does not work on this build. Disabling it the classic way..."
	Set-Service -Name wuauserv -StartupType Disabled
	Get-ScheduledTask -TaskPath '\Microsoft\Windows\WindowsUpdate\' -TaskName '*' | Unregister-ScheduledTask -Confirm:$false
	Write-Host "Alright, that's gonna be all for the manually-done series."
}
	
Write-Host -ForegroundColor Cyan "Once you press Enter, everything else should be automated!"
Read-Host
