if ($build -ge 16299) {exit}
$chonked = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").cWUfirm; if ($chonked -eq 0) {exit}

Write-Host -ForegroundColor Cyan "On builds older than 16299 (version 1709), each build/version requires installing a HUGE corresponding update (>1GB). In order to reduce the hassle for PSWindowsUpdate, the script will now download the update have you install it first. "; Write-Host -ForegroundColor Cyan "Does that sound good?" 
Write-Host "YES to proceed, anything else to skip and have PSWindowsUpdate do the job like usual."
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
	Write-Host -ForegroundColor Cyan "Alright, we will let PSWindowsUpdate handle the task."
	Start-Sleep -Seconds 5
	Write-Host " "
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
Write-Host " "; Write-Host -ForegroundColor Yellow "Wait for a while, then when it prompts you to install, click Yes and let it install the update. When it's done, you can restart using the button on the prompt, or by coming back here and pressing Enter TWICE."; Write-Host "Good luck updating!"
$hell = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").WelcomeToHell
if ($hell -eq 1 -and $hkau -eq 1) {
	Start-Process pwsh -Wait -ArgumentList "-WindowStyle Hidden -Command $workdir\music\musicr.ps1" -WorkingDirectory $workdir\music
	taskkill /f /im pwsh.exe
	taskkill /f /im WinXShell.exe
	Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\WinXShell\background.jpg" -NewName "oldground.jpg"
	Copy-Item -Path "$workdir\utils\hellground.jpg" -Destination "$env:SYSTEMDRIVE\Bionic\WinXShell\background.jpg"
	Write-Host " "; Write-Host "1607 detected. " -n; Write-Host -ForegroundColor Black -BackgroundColor Red "WELCOME TO HELL" -n; Write-Host ([char]0xA0)
	Start-Process "$env:SYSTEMDRIVE\Bionic\WinXShell\WinXShell.exe"
	Start-Process pwsh -ArgumentList "-WindowStyle Hidden -Command $workdir\modules\essential\setupmusic.ps1"
	Start-Sleep -Seconds 7
	Move-Item -Path "$env:SYSTEMDRIVE\Bionic\WinXShell\oldground.jpg" -Destination "$env:SYSTEMDRIVE\Bionic\WinXShell\background.jpg" -Force
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "WelcomeToHell" -Value 0 -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "cWUfirm" -Value 0 -Type DWord -Force
}
Read-Host; Read-Host
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Looks like you're done. Restarting..." -n; Write-Host ([char]0xA0)
Start-Sleep -Seconds 5
shutdown -r -t 0
Start-Sleep -Seconds 30
