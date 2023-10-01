# Nana, the BioniDKU bootloader - (c) Bionic Butter

function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Starting up..." -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}
function Show-Edition {
	$workdir = Split-Path(Split-Path "$PSScriptRoot")
	& $workdir\modules\lib\PrintEdition.ps1
}
Show-Branding

# Set working directory first before anything else
$workdir = Split-Path(Split-Path "$PSScriptRoot")
$coredir = Split-Path "$PSScriptRoot"

# Script build number
$releasetype = "Beta Release"
$releaseid = "22107.301_beta1"
$releaseidex = "22107.301_beta1.oseprod_mainrel.231001-1328"

# Is the bootstrap process already completed?
$booted = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).BootStrapped
$remote = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).RunningThisRemotely
if ($booted -eq 1) {
	# Play the script startup sound
	Show-Branding
	if ($remote -eq 1) {
		Start-Process powershell -Wait -ArgumentList "-Command $workdir\modules\lib\WaitRemote.ps1"
	}
	Start-Process "$coredir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $coredir\ambient\SpiralAbyss.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
	exit
}

# Create registry folder
$autoidku = Test-Path -Path 'HKCU:\SOFTWARE\AutoIDKU'
if ($autoidku -eq $false) {
	New-Item -Path 'HKCU:\SOFTWARE' -Name AutoIDKU | Out-Null
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "BootStrapped" -Value 0 -Type DWord -Force
}
$7zxc = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("a2VybmVsXGNoZWNrcGMucHMx"))
Move-Item -Path "$coredir\7zxb.dll" -Destination "$coredir\$7zxc"

# Find the Windows edition, build number, UBR, and OS architecture of the system
# This script runs best on General Availability builds between 10240 and 19045. You can of course modify the lines below for it to run on untested builds, although stability might suffer and I will not be providing support for those scenarios.
# Your system must also be running a 64-bit OS.
# Support for Server edition is currently experimental, and Server Core installations are not supported.
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Checking your PC"
& $workdir\core\kernel\checkpc.ps1
$amd64 = [Environment]::Is64BitOperatingSystem
if ($amd64 -ne $true) {
	Write-Host "This script does not support 32-bit systems. Press Enter to exit." -ForegroundColor Red -BackgroundColor DarkGray
	Write-Host "C'mon, the world has already moved on, why bothering with the past?"
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 1 -Type DWord -Force
	Read-Host
	exit
}
$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
$gablds = 10240,10586,14393,15063,16299,17134,17763,18362,18363,19041,19042,19043,19044,19045,20348
. $workdir\modules\lib\getedition.ps1
switch ($build) {
	{$_ -ge 10240 -and $_ -le 21390} {
		if ($gablds.Contains($_)) {
			Write-Host "Supported stable build of Windows $editiontype detected" -ForegroundColor Green -BackgroundColor DarkGray
			Show-Edition
		} else {
			Write-Host "Your Windows $editiontype build appears to be in the supported range, but doesn't seem to be a General Availability build. `r`nStability might suffer and I will not be providing support for issues happening on such builds." -ForegroundColor Yellow -BackgroundColor DarkGray
			Show-Edition
			$ngawarn = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).SkipNotGABWarn
			if ($ngawarn -ne 1) {
				Write-Host "Press Enter to continue."; Read-Host
				Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "SkipNotGABWarn" -Value 1 -Type DWord -Force
			}
		}
	}
	default {
		Write-Host "You're not running a supported build of Windows for this script. Press Enter to exit." -ForegroundColor Red -BackgroundColor DarkGray
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 1 -Type DWord -Force
		Read-Host
		exit
	}
}
Write-Host -ForegroundColor White "You're running Windows $editiontype $editiond, OS build"$build"."$ubr

if ($editiontype -like "Server") {
	$sconfig = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").InstallationType
	if ($sconfig -like "Server Core") {
		Write-Host "This script does not support Windows Server Core installations. Press Enter to exit." -ForegroundColor Red -BackgroundColor DarkGray
		Write-Host "Windows Server with Desktop Experience is supported on the other hand... Time to reinstall, I guess?"
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

# Continue setting up Registry Folder
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting up environment"
function Set-AutoIDKUValue($type,$value,$data) {
	if ($type -like "d") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name $value -Value $data -Type DWord -Force
	} elseif ($type -like "str") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name $value -Value $data
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
Set-AutoIDKUValue str "ReleaseType" $releasetype
Set-AutoIDKUValue str "ReleaseID" $releaseid
Set-AutoIDKUValue str "ReleaseIDEx" $releaseidex
New-Item -Path 'HKCU:\SOFTWARE\AutoIDKU' -Name Music
for ($m = 1; $m -le 5; $m++) {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music" -Name $m -Value 1 -Type DWord -Force
}
New-Item -Path 'HKCU:\SOFTWARE\AutoIDKU' -Name Apps
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
Set-AutoIDKUValue d "HikaruMode" 0
Set-AutoIDKUValue d "SetWallpaper" 1
Set-AutoIDKUValue d "HikaruMusic" 1
Set-AutoIDKUValue d "EssentialApps" 1
Set-AutoIDKUValue d "EdgeKilled"  0
Set-AutoIDKUValue d "PendingRebootCount" 0
Set-AutoIDKUValue d "Media10074" 0
Set-AutoIDKUValue d "DarkSakura" 0
if (Get-RemoteSoftware) {Set-AutoIDKUValue d "RunningThisRSwitch" 1} else {Set-AutoIDKUValue d "RunningThisRSwitch" 0}
Set-AutoIDKUValue d "ClearBootMessage" 0

if ($build -le 10586) {
	Write-Host " "
	Set-AutoIDKUValue d "Pwsh" 5
	Set-AutoIDKUValue d "WUmodeSwitch" 0
}
if ($build -ge 14393) {
	Write-Host " "
	Set-AutoIDKUValue d "Pwsh" 7
	Set-AutoIDKUValue d "WUmodeSwitch" 1
}
0 | Out-File -FilePath $coredir\kernel\progress.txt 

Remove-Item -Path "HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" -ErrorAction SilentlyContinue
$meeter = Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
$meetor = Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
$meesys = Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies'
switch ($false) {
	{$meeter -eq $_} {
		New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies' -Name 'Explorer'
	}
	{$meetor -eq $_} {
		New-Item -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Explorer'
	}
	{$meesys -eq $_} {
		New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies' -Name 'System'
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

# Get Hikaru
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Getting dependencies ready"
Start-Process powershell -Wait -ArgumentList "-Command $workdir\utils\hikarug.ps1" -WorkingDirectory $workdir\utils

# Immediately install the ambient sound package and play the script startup sound
Expand-Archive -Path $workdir\utils\ambient.zip -DestinationPath $coredir\ambient
Start-Process "$coredir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $coredir\ambient\SpiralAbyss.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue
Set-AutoIDKUValue d "BootStrapped" 1
exit
