Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Configuring Hikaru-chan"

reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\ShellHikaru.reg"
$hkreg = Test-Path -Path 'HKCU:\SOFTWARE\Hikaru-chan'
if ($hkreg -eq $false) {
	New-Item -Path 'HKCU:\SOFTWARE' -Name Hikaru-chan
}
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "StartupSoundVariant" -Value 1 -Type DWord -Force

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
}
if ($desktopversion -and $ngawarn -ne 1 -and $editiok.Contains($edition)) {
	Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "PaintDesktopVersion" -Value 1 -Type DWord -Force
	$hkrdeskver = 
@"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v $hkrbuildkey /t REG_SZ /d "?????.????_release.??????-????" /f
"@
} else {
	$hkrdeskver = 
@"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v $hkrbuildkey /t REG_SZ /d "?????.????_release.??????-????" /f
"@
	if ($desktopversion) {
		Write-Host -ForegroundColor Black -BackgroundColor Red "Welp,"
		Write-Host -ForegroundColor Red "The script could not perform the DesktopVersion mod." -n; Write-Host " This is likely because:"
		Write-Host "- Either you are not running on a General Availability build"
		Write-Host "- Or you are not running Home, Pro or Enterprise editions of Windows 10"
		Start-Sleep -Seconds 3
	}
}

# Write the customized values to the on-demand batch file
@"
@echo off
rem ####### Hikaru-chan by Bionic Butter #######

$hkrdeskver
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
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BioniDKU Quick Menu Tray" -Value "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe" -Type String -Force

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

Copy-Item -Path $env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe -Destination "$env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationFrameHost.exe"
Copy-Item -Path $coredir\7za.exe -Destination "$env:SYSTEMDRIVE\Windows\7za.exe"
Copy-Item -Path $coredir\7zxa.dll -Destination "$env:SYSTEMDRIVE\Windows\7zxa.dll"
taskkill /f /im ApplicationFrameHost.exe
takeown /f "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe"
icacls "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe" /grant Administrators:F
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name DisallowRun -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTrayContextMenu -Value 0 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData" -Name AllowLockScreen -Value 0 -Type DWord
[System.Environment]::SetEnvironmentVariable('HikaruToken','3', 'Machine')
reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestrict.reg"
