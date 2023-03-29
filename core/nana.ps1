function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta
	Write-Host "Starting up..." -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}
Show-Branding

# Set Working Directory first before anything else
$workdir = "$PSScriptRoot\.."

# Script build number
$releasetype = "Beta Release"
$releaseid = "Build 22107.201_b6.oseprod_betarel.230329-0006"

# Is the bootstrap process already completed?
$booted = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).BootStrapped
if ($booted -eq 1) {
	# Play the script startup sound
	Show-Branding
	Start-Process "$PSScriptRoot\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $PSScriptRoot\ambient\SpiralAbyss.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
	exit
}

# Create registry folder
$autoidku = Test-Path -Path 'HKCU:\SOFTWARE\AutoIDKU'
if ($autoidku -eq $false) {
	New-Item -Path 'HKCU:\SOFTWARE' -Name AutoIDKU | Out-Null
}

# Find the build number, UBR, and OS architecture of the system
# This script runs best on General Availability builds between 10240 and 19045. You can of course modify the lines below for it to run on untested builds, although stability might suffer and I will not be providing support for those scenarios.
# Your system must also be running a 64-bit OS.
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Checking your PC"
$amd64 = [Environment]::Is64BitOperatingSystem
if ($amd64 -ne $true) {
	Write-Host "This script does not support 32-bit systems. Press Enter to exit." -ForegroundColor Red -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
	Write-Host "C'mon, the world has already moved on, why bothering with the past?"
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 1 -Type DWord -Force
	Read-Host
	exit
}
$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
$gablds = 10240,10586,14393,15063,16299,17134,17763,18362,18363,19041,19042,19043,19044,19045
switch ($build) {
	{$_ -ge 10240 -and $_ -le 19045} {
		if ($gablds.Contains($_) -eq $true) {
			Write-Host "Supported stable build of Windows 10 detected" -ForegroundColor Green -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
		} else {
			Write-Host "Your Windows 10 build appears to be in the supported range, but doesn't seem to be a General Availability build. `r`nStability might suffer and I will not be providing support for issues happening on such builds." -ForegroundColor Yellow -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
			$ngawarn = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).SkipNotGABWarn
			if ($ngawarn -ne 1) {
				Write-Host "Press Enter to continue."; Read-Host
				Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "SkipNotGABWarn" -Value 1 -Type DWord -Force
			}
		}
	}
	default {
		Write-Host "You're not running a supported build of Windows for this script. Press Enter to exit." -ForegroundColor Red -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 1 -Type DWord -Force
		Read-Host
		exit
	}
}
Write-Host "You're running Windows 10 build"$build"."$ubr

Write-Host " "
Write-Host "Windows Update settings will be immediately modified once the script continues loading." -ForegroundColor Black -BackgroundColor Yellow
Write-Host "I'm giving you 7 seconds to close this window before that happens." -ForegroundColor Black -BackgroundColor Yellow
Start-Sleep -Seconds 7

# Continue setting up Registry Folder
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting up environment"
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "BootStrapped" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ReleaseType" -Value $releasetype
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ReleaseID" -Value $releaseid
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "SetWallpaper" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMusic" -Value 1 -Type DWord -Force
New-Item -Path 'HKCU:\SOFTWARE\AutoIDKU' -Name Music
for ($m = 1; $m -le 5; $m++) {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music" -Name $m -Value 1 -Type DWord -Force
}
Remove-Item -Path "HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" -Name "DisableStartupSound" -Value 1 -Type DWord -Force
$meeter = Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
$meetor = Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
switch ($false) {
	{$meeter -eq $_} {
		New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies' -Name 'Explorer'
	}
	{$meeter -eq $_} {
		New-Item -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Explorer'
	}
}

# Take control over Windows Update so it doesn't do stupid.
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Taking control over Windows Update" -n; Write-Host " (so it doesn't do stupid)" -ForegroundColor White
switch ($build) {
    {$_ -ge 10240 -and $_ -le 19041} {$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ReleaseId}
    {$_ -ge 19042 -and $_ -le 19044} {$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion}
}
$wudir = (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate)
if ($wudir -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name 'WindowsUpdate'}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersionInfo' -Value $version -Type String -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersion' -Value 1 -Type DWord -Force
$msrtdir = (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\MRT)
if ($msrtdir -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Name 'MRT'}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name 'DontOfferThroughWUAU' -Value 1 -Type DWord -Force
$noau = Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
if ($noau -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name AU}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name AUOptions -Value 2 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAutoUpdate -Value 1 -Type DWord -Force
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue

# Apply TLS settings, which will take effect immediately when launching main.ps1
if ($build -le 17134 -and $build -ge 10240) {
	$tls1 = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319').SchUseStrongCrypto
	$tls2 = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319').SchUseStrongCrypto
	if ($tls1 -eq 0 -or $tls2 -eq 0 -or $null -eq $tls1 -or $null -eq $tls2) {
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
	}
}

# Get the utilities package
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Getting dependencies ready"
Start-Process powershell -Wait -ArgumentList "-Command $PSScriptRoot\..\utils\utilsg.ps1" -WorkingDirectory $PSScriptRoot\..\utils

# Immediately install the ambient sound package and play the script startup sound
Expand-Archive -Path $workdir\utils\ambient.zip -DestinationPath $workdir\core\ambient
Start-Process "$PSScriptRoot\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $PSScriptRoot\ambient\SpiralAbyss.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue

if ($build -le 10586) {
	Write-Host " "
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Pwsh" -Value 5 -Type DWord -Force
}
if ($build -ge 14393) {
	Write-Host " "
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Pwsh" -Value 7 -Type DWord -Force
}
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "BootStrapped" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditing" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ChangesMade" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "EdgeKilled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "PendingRebootCount" -Value 0 -Type DWord -Force
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue
exit
