Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Configuring Hikaru-chan"

$ds = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").DarkSakura
if ($ds -eq 1) {$var = 3} else {$var = 1}
reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\ShellHikaru.reg"
$hkreg = Test-Path -Path 'HKCU:\SOFTWARE\Hikaru-chan'
if ($hkreg -eq $false) {
	New-Item -Path 'HKCU:\SOFTWARE' -Name Hikaru-chan
}
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "ProductName" -Value "BioniDKU" -Type String -Force
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "StartupSoundVariant" -Value $var -Type DWord -Force
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikarefreshinfo.ps1 -O HikarefreshinFOLD.ps1" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikarefresh" 
Show-WindowTitle noclose

# Hikarun on-demand customization section
if ($hidetaskbaricons -and $build -ge 18362) {
	$hkrdockico = 
@"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAMeetNow /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v IsFeedsAvailable /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f
"@
} else {$hkrdockico = ""}
if ($pwsh -eq 7) {
	$hkrdelwwa = "del $env:SYSTEMDRIVE\Windows\System32\WWAHost.exe"
} else {$hkrdelwwa = ""}
$ngawarn = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SkipNotGABWarn
$edition = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").EditionID
$editiok = "Professional","Core","Enterprise"
if ($pwsh -eq 5) {
	$hkrbuildkey = "CurrentBuildNumber"
} else {
	$hkrbuildkey = "BuildLab"
	$hkrbuildog = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").BuildLab
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "BuildLabOg" -Value $hkrbuildog -Type String -Force
}
if ($desktopversion -and $ngawarn -ne 1 -and $editiok.Contains($edition)) {
	Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "PaintDesktopVersion" -Value 1 -Type DWord -Force
} else {
	if ($desktopversion) {
		Write-Host -ForegroundColor Black -BackgroundColor Red "Welp,"
		Write-Host -ForegroundColor Red "The script could not perform the DesktopVersion mod." -n; Write-Host -ForegroundColor White " This is likely because:"
		Write-Host -ForegroundColor White "- Either you are not running on a General Availability build"
		Write-Host -ForegroundColor White "- Or you are not running Home, Pro or Enterprise editions of Windows 10"
		Start-Sleep -Seconds 3
	}
}

# Also from here, reenable UAC if it's a GA build
if ($keepuac -and $ngawarn -ne 1) {Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name EnableLUA -Value 1 -Force}

# Write the customized values to the on-demand batch file
@"
@echo off
rem ####### Hikaru-chan by Bionic Butter #######

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v $hkrbuildkey /t REG_SZ /d "?????.????_release.??????-????" /f
$hkrdelwwa
$hkrdockico
"@ | Out-File -FilePath "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarun.bat" -Encoding ascii

# Install HikaruQM and pre-apply system restrictions (set restrictions but at disabled state)

$WScriptObj = New-Object -ComObject ("WScript.Shell")
$hkQML = "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe"
$hkQMLS = "$env:AppData\Microsoft\Windows\Start Menu\Programs\BioniDKU Quick Menu Tray.lnk"
$hkQMLSh = $WscriptObj.CreateShortcut($hkQMLS)
$hkQMLSh.TargetPath = $hkQML
$hkQMLSh.Save()
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BioniDKU Quick Menu Tray" -Value "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe" -Type String -Force

if ($build -eq 10586) {
	mofcomp C:\Windows\System32\wbem\SchedProv.mof
}
$hkF5action = New-ScheduledTaskAction -Execute "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefresh.exe"
$hkF5trigger = @(
	$(New-ScheduledTaskTrigger -AtLogon),
	$(New-ScheduledTaskTrigger -Daily -DaysInterval 1 -At 8am)
)
$hkF5settings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew
$hkF5 = New-ScheduledTask -Action $hkF5action -Trigger $hkF5trigger -Settings $hkF5settings
Register-ScheduledTask 'BioniDKU Quick Menu Update Checker' -InputObject $hkF5

# This line is here for Hikaru beta. Remove it on final please.
Disable-ScheduledTask 'BioniDKU Quick Menu Update Checker'

Copy-Item -Path $env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe -Destination "$env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationFrameHost.exe"
Copy-Item -Path $coredir\7z\7za.exe -Destination "$env:SYSTEMDRIVE\Windows\7za.exe"
Copy-Item -Path $coredir\7z\7zxa.dll -Destination "$env:SYSTEMDRIVE\Windows\7zxa.dll"
taskkill /f /im ApplicationFrameHost.exe
takeown /f "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe"
icacls "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe" /grant Administrators:F
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name DisallowRun -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTrayContextMenu -Value 0 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData" -Name AllowLockScreen -Value 0 -Type DWord
[System.Environment]::SetEnvironmentVariable('HikaruToken','3', 'Machine')
reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestrict.reg"
$cmd = Test-Path -Path "HKCU:\Software\Microsoft\Command Processor"
if ($cmd -eq $false) {
	New-Item -Path "HKCU:\Software\Microsoft" -Name "Command Processor"
}
