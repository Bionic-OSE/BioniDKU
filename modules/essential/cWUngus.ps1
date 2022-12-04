if ($build -ge 16299) {exit}
$chonked = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").cWUngus; if ($chonked -eq 1) {exit}

Write-Host -ForegroundColor Cyan "On builds older than 16299 (version 1709), each build/version requires installing a HUGE corresponding update (>1GB). In order to reduce the hassle for PSWindowsUpdate, the script will now download the update have you install it first. "; Write-Host -ForegroundColor Cyan "Does that sound good?" 
Write-Host "YES to continue, anything else to cancel updating."
Write-Host "Your answer: " -n ; $confules = Read-Host
switch ($confup) {
	{$confules -like "yes"} {
		Write-Host -ForegroundColor Green "Got it, starting to download the update"
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "cWUfirm" -Value 1 -Type DWord -Force
	}
	default {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "cWUfirm" -Value 0 -Type DWord -Force
	}
}
$chonkfirm = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").cWUfirm; if ($chonkfirm -eq 0) {
	Write-Host " "
	Write-Host -ForegroundColor Cyan "You have canceled the update process, which is currently are requirement in order to continue running this script."
	Write-Host 'To disable this requirement, rerun the script and set the "windowsupdate" value to FALSE. You will be taken to the configuration screen next time you run the script.'
	Write-Host -ForegroundColor Cyan "Press Enter to exit."
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 0 -Type DWord -Force
	Read-Host
	exit
}

switch ($build) {
	{$_ -eq 14393} {
		$chonkdate = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/updt/2018/04/windows10.0-kb4093120-x64_72c7d6ce20eb42c0df760cd13a917bbc1e57c0b7.msu"
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "WelcomeToHell" -Value 1 -Type DWord -Force
	}
	{$_ -eq 15063} {
		$chonkdate = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/updt/2018/10/windows10.0-kb4462939-x64_68fa7ea1928f909b1497d61c0819aebaf7c37fa8.msu"
	}
}
Start-BitsTransfer -Source $chonkdate -Destination $workdir\CHUNGUS.msu -RetryInterval 60

Write-Host "Download complete. Opening the MSU in wusa.exe so you can install it..."
Start-Process wusa.exe -NoNewWindow -ArgumentList "$workdir\CHUNGUS.msu"
Write-Host " "; Write-Host -ForegroundColor Yellow "Wait for a while, then when it prompts you to install, click Yes. Let it install the update, then when it's done and prompts for restart, " -n; Write-Host -ForegroundColor Black -BackgroundColor Yellow "DO NOT PRESS RESTART NOW!" -n; Write-Host -ForegroundColor Yellow " Come back here and press Enter TWICE in order to restart " -n; Write-Host "(so the script can save progress and be able to resume itself after restarting)."; Write-Host "Good luck updating!"
$hell = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").WelcomeToHell
if ($hell -eq 1 -and $setupmusic -eq $true) {
	Start-Process pwsh -Wait -ArgumentList "-WindowStyle Hidden -Command $workdir\music\musicr.ps1" -WorkingDirectory $workdir\music
	Write-Host " "; Write-Host "1607 detected. " -n; Write-Host -ForegroundColor Black -BackgroundColor Red "WELCOME TO HELL" -n; Write-Host ([char]0xA0)
	Music -Stop
	Music $workdir\music\redstone2 -Shuffle -Loop
	Write-Host -ForegroundColor Yellow "Again, press Enter TWICE in order to restart"
}
Read-Host; Read-Host
Write-Host "Looks like you're done. Saving progress and restarting..."
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "cWUngus" -Value 1 -Type DWord -Force
& $PSScriptRoot\..\..\core\resume.ps1
shutdown -r -t 5 -c "BioniDKU needs to restart your PC to finish installing updates"
Start-Sleep -Seconds 30
