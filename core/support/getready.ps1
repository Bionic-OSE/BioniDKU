# BioniDKU system preparation module - (c) Bionic Butter
# This module prepares the system for the next restart to download mode, and then WU mode/normal mode

function Set-AutoIDKUValue($type,$value,$data) {
	if ($type -like "d") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name $value -Value $data -Type DWord -Force
	} elseif ($type -like "str") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name $value -Value $data
	} elseif ($type -like "app") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps" -Name $value -Value $data -Type DWord -Force
	}
}
function New-KeyWithValue($location,$keyname,$value) {
	New-Item -Path "$location" -Name $keyname | Out-Null
	Set-Item -Path "$location\$keyname" -Value "$value"
}

Start-Logging PrepMode
Show-WindowTitle 1 "Getting ready" noclose
Show-Branding clear
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Getting ready"
Write-Host -ForegroundColor Yellow "You device will restart shortly after this, be prepared."
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue

& $coredir\servicing\hikarug.ps1 1

Write-Host " "
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Hooking the script to the startup sequence"
Copy-Item "$datadir\ambient\FFPlay.exe" -Destination "$env:SYSTEMDRIVE\Bionic\Hikaru"
. $coredir\kernel\minihikaru.ps1
Set-HikaruChan

switch ($true) {
	{$keepsearch} {Set-AutoIDKUValue d "SearchNoMercy" 1}
	{$explorerstartfldr} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting Explorer to open on This PC" -n; Write-Host " (will take effect next time Explorer starts)"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Value 1 -Type DWord -Force
	} {$dotnet462} {Set-AutoIDKUValue app "NET462" 1}
}
$anydesk = Test-Path -Path "$env:SYSTEMDRIVE\Program Files (x86)\AnyDesk\AnyDesk.exe" -PathType Leaf
$rustdesk = Test-Path -Path "$env:SYSTEMDRIVE\Program Files\RustDesk\RustDesk.exe" -PathType Leaf
$dwservice = Test-Path -Path "$env:SYSTEMDRIVE\Program Files\DWAgent\native\dwagsvc.exe" -PathType Leaf
$s = "HKLM:\SYSTEM\CurrentControlSet\Control\SafeBoot\Network"; $b = "Service"
switch ($true) {
	$anydesk {New-KeyWithValue $s "AnyDesk" $b}
	$rustdesk {New-KeyWithValue $s "RustDesk" $b}
	$dwservice {New-KeyWithValue $s "DWAgent" $b}
}

$ngawarn = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).NotGABuild
$windowsupdate = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").WUmodeSwitch
if ($windowsupdate -eq 1 -and $ngawarn -ne 1 -and $edition -notlike "EnterpriseG") {
	# Take control over Windows Update so it doesn't do stupid, unless if it's Home or Server edition.
	if ($edition -notmatch "Core" -or $editiontype -like "Server") {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Taking control over Windows Update" -n; Write-Host " (so it doesn't do stupid)" -ForegroundColor White
		switch ($build) {
			{$_ -ge 10240 -and $_ -le 19041} {$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ReleaseId}
			{$_ -ge 19042 -and $_ -le 19045} {$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion}
		}
		$wudir = (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate)
		if ($wudir -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name 'WindowsUpdate'}
		if ($build -ge 17134) {
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersionInfo' -Value $version -Type String -Force
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersion' -Value 1 -Type DWord -Force
		}
		$noau = Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
		if ($noau -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name AU}
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name AllowAutoUpdate -Value 5 -Type DWord -Force
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name AUOptions -Value 2 -Type DWord -Force
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAutoUpdate -Value 1 -Type DWord -Force
	}
	$msrtdir = (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\MRT)
	if ($msrtdir -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Name 'MRT'}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name 'DontOfferThroughWUAU' -Value 1 -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "WUmode" -Value 1 -Type DWord -Force
} else {Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "WUmode" -Value 0 -Type DWord -Force}

$sysrestore = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").KeepSR
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling UAC and applying some tweaks to the system"
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name ConsentPromptBehaviorAdmin -Value 0 -Force
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name EnableLUA -Value 0 -Force
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name PromptOnSecureDesktop -Value 0 -Force
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Value 0 -Type DWord -Force
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SeparateProcess' -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'DontUsePowerShellOnWinX' -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'EnableLegacyBalloonNotifications' -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" -Name "DisableStartupSound" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoRestartShell" -Value 0 -Type DWord
if ($sysrestore -eq 0) {reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v DisableSR /t REG_DWORD /d 1 /f}
Set-AutoIDKUValue d "HikaruMode" 4

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Restarting your device"
Restart-System ManualExit
$setwallpaper = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SetWallpaper
if ($setwallpaper -eq 1) {& $workdir\modules\desktop\wallpaper.ps1}

Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 0 -Type DWord -Force
Start-Sleep -Seconds 30
exit
