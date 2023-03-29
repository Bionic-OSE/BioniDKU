if ($build -ge 16299) {exit}
$chonked = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").cWUfirm; if ($chonked -eq 0) {exit}
$helloverride = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").DisableHellMode

Write-Host -ForegroundColor Cyan "For version 1607 and 1703, the update to the latest UBR comes in a HUGE corresponding update file (>1GB). In order to reduce the hassle for PSWindowsUpdate, the script will now download the update have you install it. After the installation, you can continue updating by interrupting Windows Update mode on startup. "; Write-Host -ForegroundColor White "Does that sound good?"
Write-Host "YES to proceed, anything else to skip and have PSWindowsUpdate do the job like usual." -ForegroundColor White
Write-Host " "#; Write-Host "NOTE: " -ForegroundColor Yellow -n; Write-Host "Make sure no updates are running," -ForegroundColor White -n; Write-Host " otherwise wusa.exe will refuse to open (You can check by looking for the `"Windows Modules Installer`" process via Task Manager. If it isn't there, you're safe to go. If it's there, open CMD via Run and stop the `"wuauserv`" service)"
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
		if ($helloverride -ne 1) {Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "WelcomeToHell" -Value 1 -Type DWord -Force}
	}
	{$_ -eq 15063} {
		$chonkdate = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/updt/2018/10/windows10.0-kb4462939-x64_68fa7ea1928f909b1497d61c0819aebaf7c37fa8.msu"
	}
}

$dlfe = Test-Path -Path "$workdir\dls"
$chonkexists = Test-Path -Path "$workdir\dls\CHUNGUS.msu"
Start-Process powershell -ArgumentList "-Command $workdir\removal\wukiller.ps1"
if ($dlfe -eq $false) {
	New-Item -Path $workdir -Name dls -itemType Directory | Out-Null
} if ($chonkexists -eq $false) {
	Start-BitsTransfer -Source $chonkdate -Destination $workdir\dls\CHUNGUS.msu -RetryInterval 60
	Write-Host -ForegroundColor Cyan "Download complete. Opening the MSU in wusa.exe so you can install it..."
} else {
	Write-Host -ForegroundColor Cyan "It looks like the update file has downloaded before. Moving on to handle the task to wusa.exe..."
}
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "WuKillerStop" -Value 1 -Type DWord -Force

Start-Sleep -Seconds 5
Start-Service -Name wuauserv
Start-Process wusa.exe -NoNewWindow -ArgumentList "$workdir\dls\CHUNGUS.msu"
Write-Host " "; Write-Host -ForegroundColor Yellow "Wait for a while, then when it prompts you to install, click Yes and let it install the update. When it's done, you can restart using the button on the prompt, or by coming back here and pressing Enter TWICE."
Write-Host "If wusa.exe fails to open, you can manually open the update at $workdir\dls\CHUNGUS.msu"
Write-Host "Good luck updating!" -ForegroundColor White

$hell = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").WelcomeToHell
if ($hell -eq 1 -and $hkau -eq 1) {
	Start-Process powershell -WindowStyle Hidden -Wait -ArgumentList "-Command $workdir\music\musicr.ps1" -WorkingDirectory $workdir\music
	taskkill /f /im WinXShell.exe
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMusicStop" -Value 1 -Type DWord -Force
	Start-Sleep -Seconds 1
	taskkill /f /im FFPlay.exe
	Start-Sleep -Seconds 3
	Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\WinXShell\background.jpg" -NewName "oldground.jpg"
	Copy-Item -Path "$workdir\utils\hellground.jpg" -Destination "$env:SYSTEMDRIVE\Bionic\WinXShell\background.jpg"
	Write-Host " "; Write-Host "1607 detected. " -n; Write-Host -ForegroundColor Black -BackgroundColor Red "WELCOME TO HELL" -n; Write-Host ([char]0xA0)
	Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe" -NewName "AdvancedRun.DISABLED"
	Start-Process "$env:SYSTEMDRIVE\Bionic\WinXShell\WinXShell.exe"
	Start-Process powershell -ArgumentList "-Command $workdir\music\musics.ps1"
	Start-Sleep -Seconds 6
	Move-Item -Path "$env:SYSTEMDRIVE\Bionic\WinXShell\oldground.jpg" -Destination "$env:SYSTEMDRIVE\Bionic\WinXShell\background.jpg" -Force
	Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.DISABLED" -NewName "AdvancedRun.exe"
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "WelcomeToHell" -Value 0 -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "cWUfirm" -Value 0 -Type DWord -Force
}
Read-Host; Read-Host
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Looks like you're done. Restarting..." -n; Write-Host ([char]0xA0)
Start-Sleep -Seconds 5
shutdown -r -t 0
Start-Sleep -Seconds 30
