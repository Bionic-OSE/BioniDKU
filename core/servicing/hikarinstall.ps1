Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Configuring Hikaru-chan" -n; Write-Host ([char]0xA0)

reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\ShellHikaru.reg"
$hkreg = Test-Path -Path 'HKCU:\SOFTWARE\Hikaru-chan'
if ($hkreg -eq $false) {
	New-Item -Path 'HKCU:\SOFTWARE' -Name Hikaru-chan
}
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "StartupSoundVariant" -Value 1 -Type DWord -Force

# Hikarun on-demand customization section
if ($pwsh -eq 7) {
	$hkrdelwwa = "del $env:SYSTEMDRIVE\Windows\System32\WWAHost.exe"
} else {$hkrdelwwa = ""}
$ngawarn = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SkipNotGABWarn
$edition = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").EditionID
$editiok = "Professional","Core","Enterprise"
if ($desktopversion -and $ngawarn -ne 1 -and $editiok.Contains($edition)) {
	Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "PaintDesktopVersion" -Value 1 -Type DWord -Force
	if ($pwsh -eq 5) {
		$hkrbuildkey = "CurrentBuildNumber"
	} else {
		$hkrbuildkey = "BuildLab"
	}
	$hkrdeskver = 
@"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v $hkrbuildkey /t REG_SZ /d "?????.????_release.??????-????" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v legalnoticecaption /t REG_SZ /d "Uh oh..." /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v legalnoticetext /t REG_SZ /d "If you are seeing this message, the OS might have been improperly shut down during startup and as a result, your desktop's bottom right corner will reveal the build string. Please contact your challenge host to resolve this issue, and until then, do not sign in (or you will regret what you may see)." /f
"@
} elseif ($desktopversion) {
	Write-Host -ForegroundColor Black -BackgroundColor Red "Welp,"
	Write-Host -ForegroundColor Red "The script could not perform the DesktopVersion mod." -n; Write-Host " This is likely because:"
	Write-Host "- Either you are not running on a General Availability build"
	Write-Host "- Or you are not running Home, Pro or Enterprise editions of Windows 10"
	Start-Sleep -Seconds 3
	$hkrdeskver = 
@"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v legalnoticecaption /t REG_SZ /d "Uh oh..." /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v legalnoticetext /t REG_SZ /d "If you are seeing this message, the OS might have been improperly shut down during startup. Your system may continue to load properly despite the issue, but it is recommended to contact your challenge host as soon as possible." /f
"@
} else {$hkrdeskver = ""}

@"
@echo off
rem ####### Hikaru-chan by Bionic Butter #######

$hkrdelwwa
$hkrdeskver
"@ | Out-File -FilePath "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarun.bat" -Encoding ascii

# Install HikaruQM and pre-apply system restrictions (set restrictions but at disabled state)

$WScriptObj = New-Object -ComObject ("WScript.Shell")
$hkQML = "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe"
$hkQMLS = "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\HikaruQML.lnk"
$hkQMLSh = $WscriptObj.CreateShortcut($hkQMLS)
$hkQMLSh.TargetPath = $hkQML
$hkQMLSh.Save()

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
reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestrict.reg"
