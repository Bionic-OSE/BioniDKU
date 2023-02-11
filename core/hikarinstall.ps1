Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Configuring Hikaru-chan" -n; Write-Host ([char]0xA0)

reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\ShellHikaru.reg"
$hkreg = Test-Path -Path 'HKCU:\SOFTWARE\Hikaru-chan'
if ($hkreg -eq $false) {
	New-Item -Path 'HKCU:\SOFTWARE' -Name Hikaru-chan
}
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UseOSSEStartupSound" -Value 0 -Type DWord -Force

# Hikarun on-demand customization section
if ($pwsh -eq 7) {
	$hkrdelwwa = "del $env:SYSTEMDRIVE\Windows\System32\WWAHost.exe"
} else {$hkrdelwwa = ""}
$ngawarn = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SkipNotGABWarn
$edition = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").EditionID
$editiok = "Professional","Core"
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
"@
} elseif ($desktopversion) {
	Write-Host -ForegroundColor Black -BackgroundColor Red "Welp,"
	Write-Host -ForegroundColor Red "The script could not perform the DesktopVersion mod." -n; Write-Host "This is likely because:"
	Write-Host "- Either you are not running on a General Availability build"
	Write-Host "- Or you are not running Home or Pro editions of Windows 10"
	Start-Sleep -Seconds 3
	$hkrdeskver = ""
} else {$hkrdeskver = ""}

@"
@echo off
rem ####### Hikaru-chan by Bionic Butter #######

$hkrdelwwa
$hkrdeskver
"@ | Out-File -FilePath "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarun.bat" -Encoding ascii

# Install HikaruQM and pre-apply system restrictions (set restrictions but at disabled state)
Move-Item -Path $env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe -Destination "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\HikaruQML.exe"
Copy-Item -Path $env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe -Destination "$env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationFrameHost.exe"
taskkill /f /im ApplicationFrameHost.exe
takeown /f "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe"
icacls "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe" /grant Administrators:F
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name DisallowRun -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTrayContextMenu -Value 0 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData" -Name AllowLockScreen -Value 0 -Type DWord
reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestrict.reg"
