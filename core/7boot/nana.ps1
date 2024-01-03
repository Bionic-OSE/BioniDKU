# Nana, the BioniDKU bootloader - (c) Bionic Butter

function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Starting up..." -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}

Show-Branding
if (($ExecutionContext.SessionState.LanguageMode) -ne "FullLanguage") {
	Write-Host "It appears that your device's PowerShell has been restricted." -ForegroundColor Black -BackgroundColor Red
	Write-Host "Certain things will not work and the script does not like that at all." -ForegroundColor Red
	Write-Host "This is happening possibly due to:" -ForegroundColor White
	Write-Host " - Your device is under a managed network that's enforcing restricted PowerShell." -ForegroundColor White
	Write-Host " - The limitation is coming from your configuration (Secure Boot policies, WDAC,...)." -ForegroundColor White
	Write-Host "The ability to solve this problem depends on the level of restriction. However, for most cases when this is happening, there's likely more restrictions in place that will prevent the script from working later on. Whatever is the case, please report this to me."
	Write-Host "Press Enter to exit."
	Read-Host; exit
}

. $PSScriptRoot\versioninfo.ps1

# Set and create working directories first before anything else
$global:workdir = Split-Path(Split-Path "$PSScriptRoot")
$global:coredir = Split-Path "$PSScriptRoot"
if (-not (Test-Path -Path "$workdir\data")) {New-Item -Path $workdir -Name "data" -itemType Directory | Out-Null}
$global:datadir = "$workdir\data"
if (-not (Test-Path -Path "$datadir\dls")) {New-Item -Path $datadir -Name "dls" -itemType Directory | Out-Null}
if (-not (Test-Path -Path "$datadir\values")) {New-Item -Path $datadir -Name "values" -itemType Directory | Out-Null}
if (-not (Test-Path -Path "$datadir\logs")) {New-Item -Path $datadir -Name "logs" -itemType Directory | Out-Null}

# Is the bootstrap process already completed? Or is the run already completed?
$booted = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).BootStrapped
$comped = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).ALLCOMPLETED
$remote = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).RunningThisRemotely
$isexplorerup = Get-Process -Name explorer -ErrorAction SilentlyContinue
Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Ambient.psm1
if ($comped -eq 16384) {exit}
elseif ($booted -eq 1) {
	# Play the script startup sound
	if ($remote -eq 1 -and -not $isexplorerup) {
		Start-Process powershell -Wait -ArgumentList "-Command $workdir\modules\lib\Wait-Remote.ps1"
	}
	Play-Ambient 0
	exit
}

# Create registry folder
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting up environment"
$autoidku = Test-Path -Path 'HKCU:\SOFTWARE\AutoIDKU' -ErrorAction SilentlyContinue
$bionidku = Test-Path -Path 'HKCU:\SOFTWARE\BioniDKU' -ErrorAction SilentlyContinue
$adkumsic = Test-Path -Path 'HKCU:\SOFTWARE\AutoIDKU\Music' -ErrorAction SilentlyContinue
$adkuapps = Test-Path -Path 'HKCU:\SOFTWARE\AutoIDKU\Apps' -ErrorAction SilentlyContinue
switch ($false) {
	$autoidku {New-Item -Path 'HKCU:\SOFTWARE' -Name AutoIDKU | Out-Null}
	$bionidku {New-Item -Path 'HKCU:\SOFTWARE' -Name BioniDKU | Out-Null}
	$adkumsic {New-Item -Path 'HKCU:\SOFTWARE\AutoIDKU' -Name Music | Out-Null}
	$adkuapps {New-Item -Path 'HKCU:\SOFTWARE\AutoIDKU' -Name Apps | Out-Null}
}

# Find the Windows edition, build number, UBR, and OS architecture of the system
# This script runs best on General Availability builds between 10240 and 19045. You can of course modify the lines below for it to run on untested builds, although stability might suffer and I will not be providing support for those scenarios.
# Your system must also be running a 64-bit OS.
# Support for Server edition is currently experimental, and Server Core installations are not supported.
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Checking your PC"
$amd64 = [Environment]::Is64BitOperatingSystem
if ($amd64 -ne $true) {
	Write-Host "This script does not support 32-bit systems." -ForegroundColor Black -BackgroundColor Red -n; Write-Host " Press Enter to exit."
	Write-Host "C'mon, the world has already moved on, why bothering with the past?"
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 1 -Type DWord -Force
	Read-Host
	exit
}
. $coredir\kernel\osinfo.ps1
$gablds = 10240,10586,14393,15063,16299,17134,17763,18362,18363,19041,19042,19043,19044,19045,20348
switch ($build) {
	{$_ -ge 10240 -and $_ -le 21390} {
		if ($gablds.Contains($_)) {
			Write-Host "Supported stable build of Windows $editiontype detected" -ForegroundColor Green -BackgroundColor DarkGray
		} else {
			Write-Host "Supported non-General Availability build of Windows $editiontype detected" -ForegroundColor Yellow -BackgroundColor DarkGray
			Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "NotGABuild" -Value 1 -Type DWord -Force
			Start-Sleep -Seconds 1
		}
	}
	default {
		Write-Host "You're not running a supported build of Windows for this script." -ForegroundColor Black -BackgroundColor Red -n; Write-Host " Press Enter to exit."
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 1 -Type DWord -Force
		Read-Host
		exit
	}
}
Write-OSInfo

if ($editiontype -like "Server") {
	$sconfig = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").InstallationType
	if ($sconfig -like "Server Core") {
		Write-Host "This script does not support Server Core installations." -ForegroundColor Black -BackgroundColor Red -n; Write-Host " Press Enter to exit."
		Write-Host "Server with Desktop Experience is supported on the other hand... Time to reinstall, I guess?"
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 1 -Type DWord -Force
		Read-Host
		exit
	}
	Write-Host " "
	Write-Host "Server edition detected" -ForegroundColor Black -BackgroundColor Yellow
	Write-Host "Support for this edition is currently experimental. Beware that things might break." -ForegroundColor Yellow -BackgroundColor DarkGray
	Start-Sleep -Seconds 3
	Write-Host " "
}
switch ($edition) {
	{$_ -like "PPIPro"} {
		Write-Host " "
		Write-Host "This script does not support Team edition." -ForegroundColor Black -BackgroundColor Red
		if ($build -ge 19041 -and $build -le 19045) {Write-Host "To use the script, you will need to PPISwap this device to either Enterprise or Pro edition." -ForegroundColor White} else {Write-Host "And PPISwap does not support this build either. So don't try." -ForegroundColor Red; Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 1 -Type DWord -Force}
		Write-Host " Press Enter to exit."
		Read-Host; exit
	}
	{$_ -like "Core"} {
		Write-Host " "
		Write-Host "Home edition detected" -ForegroundColor Black -BackgroundColor Yellow
		Write-Host "Beware that certain system restrictions, like blocking Feature updates in Windows Update will NOT work with this edition." -ForegroundColor Yellow -BackgroundColor DarkGray
		Start-Sleep -Seconds 3
		Write-Host " "
	}
	{$_ -like "EnterpriseG"} {
		Write-Host " "
		Write-Host "China Government edition detected" -ForegroundColor Black -BackgroundColor Yellow
		Write-Host "Windows Update mode will be automatically disabled on this edition, as CMGE's custom update policies can cause issues with this mode." -ForegroundColor Yellow -BackgroundColor DarkGray
		Start-Sleep -Seconds 3
		Write-Host " "
	}
}

# Continue setting up registry folder after all the checks are completed
function Set-AutoIDKUValue($type,$value,$data) {
	if ($type -like "d") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name $value -Value $data -Type DWord -Force
	} elseif ($type -like "str") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name $value -Value $data -Type String -Force
	} elseif ($type -like "app") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps" -Name $value -Value $data -Type DWord -Force
	}
}
function Get-RemoteSoftware {
	# AnyDesk, RustDesk and DWService are currently supported
	$anydesk = Test-Path -Path "$env:SYSTEMDRIVE\Program Files (x86)\AnyDesk\AnyDesk.exe"
	$rustdesk = Test-Path -Path "$env:SYSTEMDRIVE\Program Files\RustDesk\RustDesk.exe"
	$dwservice = Test-Path -Path "$env:SYSTEMDRIVE\Program Files\DWAgent\native\dwagsvc.exe"
	$anydeskon = Get-Process AnyDesk -ErrorAction SilentlyContinue
	$rustdeskon = Get-Process RustDesk -ErrorAction SilentlyContinue
	$dwserviceon = Get-Process dwagsvc -ErrorAction SilentlyContinue
	if ($anydesk -or $rustdesk -or $anydeskon -or $rustdeskon) {
		return $true
	} else {return $false}
}

for ($m = 1; $m -le 5; $m++) {
	if ($m -notin 3, 4) {Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music" -Name $m -Value 1 -Type DWord -Force}
	else {Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music" -Name $m -Value 0 -Type DWord -Force}
}

Set-ItemProperty -Path "HKCU:\Software\BioniDKU" -Name "ReleaseType" -Value $releasetype -Type String -Force 
Set-ItemProperty -Path "HKCU:\Software\BioniDKU" -Name "ReleaseID" -Value $releaseid -Type String -Force 
Set-ItemProperty -Path "HKCU:\Software\BioniDKU" -Name "ReleaseIDEx" -Value $releaseidex -Type String -Force

Set-AutoIDKUValue app WinaeroTweaker 1
Set-AutoIDKUValue app OpenShell 1
Set-AutoIDKUValue app TClock 1
Set-AutoIDKUValue app Firefox 1
Set-AutoIDKUValue app NPP 1
Set-AutoIDKUValue app ShareX 1
Set-AutoIDKUValue app PDN 1
Set-AutoIDKUValue app PENM 1
Set-AutoIDKUValue app ClassicTM 1
Set-AutoIDKUValue app DesktopInfo 1
Set-AutoIDKUValue app VLC 1

Set-AutoIDKUValue d "ConfigSet" 0
Set-AutoIDKUValue d "ConfigEditing" 0 
Set-AutoIDKUValue d "ConfigEditingSub" 0 
Set-AutoIDKUValue d "ChangesMade" 0
Set-AutoIDKUValue d "Denied" 0
Set-AutoIDKUValue d "EdgeKilled"  0
Set-AutoIDKUValue d "EssentialApps" 1
Set-AutoIDKUValue d "Media10074" 0
Set-AutoIDKUValue d "HikaruMode" 0
Set-AutoIDKUValue d "HikaruMusic" 1
Set-AutoIDKUValue d "PendingRebootCount" 0
Set-AutoIDKUValue d "Transcribe" 1
Set-AutoIDKUValue d "SetWallpaper" 1
Set-AutoIDKUValue d "WUmodeSwitch" 1

if (Get-RemoteSoftware) {Set-AutoIDKUValue d "RunningThisRemotely" 1} else {Set-AutoIDKUValue d "RunningThisRemotely" 0}
if ($build -le 10586) {Set-AutoIDKUValue d "Pwsh" 5}
elseif ($build -ge 14393) {Set-AutoIDKUValue d "Pwsh" 7}

0 | Out-File -FilePath $datadir\values\progress.txt 

Remove-Item -Path "HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" -ErrorAction SilentlyContinue
$meeter = Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
$meetor = Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
$meesys = Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies'
switch ($false) {
	{$meeter -eq $_} {
		New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies' -Name 'Explorer' | Out-Null
	}
	{$meetor -eq $_} {
		New-Item -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Explorer' | Out-Null
	}
	{$meesys -eq $_} {
		New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies' -Name 'System' | Out-Null
	}
}

Stop-Service -Name wuauserv -ErrorAction SilentlyContinue
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue

# Apply TLS settings, which will take effect immediately when a new PowerShell process is launched
if ($build -le 17134 -and $build -ge 10240) {
	$tls1 = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319').SchUseStrongCrypto
	$tls2 = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319').SchUseStrongCrypto
	if ($tls1 -eq 0 -or $tls2 -eq 0 -or $null -eq $tls1 -or $null -eq $tls2) {
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
	}
}

# Get the ambient sound package and play the script startup sound
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Getting dependencies ready"
while ($true) {
	Start-Process powershell -Wait -ArgumentList "-Command $coredir\servicing\hikarug.ps1 0"
	$aexists = Test-Path -Path "$datadir\ambient"
	if ($aexists) {break}
	Start-Sleep -Seconds 1
}
Play-Ambient 0
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue
Set-AutoIDKUValue d "BootStrapped" 1
exit
