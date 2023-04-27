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
$releasetype = "Stable Release"
$releaseid = "22107.300_stable"
$releaseidex = "22107.300_stable.oseprod_mainrel.230427-2237"

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

# ;)
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("IyBDb25ncmF0dWxhdGlvbnMsIHlvdSBoYXZlIGZvdW5kIHRoZSBmaXJzdCB0d28gZWFzdGVyIGVnZ3MgaW4gQmlvbmlES1UgKHRoZSBvdGhlciBvbmUgYmVpbmcgdGhlIGNodW5rIG9mIEJhc2U2NCBjb2RlIGJlbG93IHRoaXMgb25lKS4gWWVzLCBzdXBwb3J0IGZvciBTZXJ2ZXIgaXMgYW4gdW5kb2N1bWVudGVkIGZlYXR1cmUgb2YgQmlvbmlES1UsIGFzIHlvdSBtYXkgaGF2ZSBub3RpY2VkIGluIHRoZSBsb3dlciBzZWN0aW9uIG9mIHRoaXMgY29kZS4NCg0KJGVkaXRpb24gPSAoR2V0LUl0ZW1Qcm9wZXJ0eSAtUGF0aCAiSEtMTTpcU09GVFdBUkVcTWljcm9zb2Z0XFdpbmRvd3MgTlRcQ3VycmVudFZlcnNpb24iKS5FZGl0aW9uSUQNCnN3aXRjaCAoJGVkaXRpb24pIHsNCglkZWZhdWx0IHskZWRpdGlvbmQgPSAiMTAgJGVkaXRpb24ifQ0KCXskXyAtbGlrZSAiQ29yZSJ9IHskZWRpdGlvbmQgPSAiMTAgSG9tZSJ9DQoJeyRfIC1saWtlICJQcm9mZXNzaW9uYWwifSB7JGVkaXRpb25kID0gIjEwIFBybyJ9DQoJeyRfIC1saWtlICJFbnRlcnByaXNlUyJ9IHsNCgkJaWYgKCRidWlsZCAtZXEgMTQzOTMpIHskZWRpdGlvbmQgPSAiMTAgTFRTQiAyMDE2In0NCgkJZWxzZWlmICgkYnVpbGQgLWVxIDE3NzYzKSB7JGVkaXRpb25kID0gIjEwIExUU0MgMjAxOSJ9DQoJCWVsc2VpZiAoJGJ1aWxkIC1lcSAxOTA0NCkgeyRlZGl0aW9uZCA9ICIxMCBMVFNDIDIwMjEifQ0KCQllbHNlIHskZWRpdGlvbmQgPSAiMTAgTFRTQi9MVFNDIn0NCgl9DQoJeyRfIC1saWtlICJTZXJ2ZXJTdGFuZGFyZCIgLW9yICRfIC1saWtlICJTZXJ2ZXJEYXRhY2VudGVyIn0gew0KCQkjIEFzIGEgbWF0dGVyIG9mIGZhY3QsIFNlcnZlciBpcyB0ZWNobmlhbGx5IHJlZ3VsYXIgV2luZG93cyBidXQgd2l0aCBTZXJ2ZXIgc3R1ZmZzIGJ1bmRsZWQuDQoJCWlmICgkYnVpbGQgLWVxIDE0MzkzKSB7JGVkaXRpb25kID0gIlNlcnZlciAyMDE2In0NCgkJZWxzZWlmICgkYnVpbGQgLWVxIDE3NzYzKSB7JGVkaXRpb25kID0gIlNlcnZlciAyMDE5In0NCgkJZWxzZWlmICgkYnVpbGQgLWVxIDIwMzQ4KSB7JGVkaXRpb25kID0gIlNlcnZlciAyMDIyIn0NCgkJZWxzZSB7JGVkaXRpb25kID0gIlNlcnZlciJ9DQoJfQ0KfQ0KDQojIFRoZXJlJ3Mgc3RpbGwgbW9yZSB0byBiZSBkaXNjb3ZlcmVkLi4uIEdvb2QgbHVjayEgPDMgZnJvbSBCaW9uaWMgQnV0dGVyLg0K")) | Out-File -FilePath $workdir\modules\lib\GetEdition.ps1
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("IyBUaGlzIGlzIHRoZSBzZWNvbmQgcGllY2Ugb2YgZWFzdGVyIGVnZyBpbiBCaW9uaURLVSwgYXNzdW1pbmcgeW91J3ZlIGNvbnZlcnRlZCB0aGUgZmlyc3Qgb25lIA0KIyBNb3N0IG9mIHlvdSBmb3Igc3VyZSB3aWxsIG5vdCBnZXQgd2hhdCB0aGVzZSBtZWFucywgc28gbGV0IG1lIGV4cGxhaW4uIExvbmcgc3Rvcnkgc2hvcnQsIHRoZXNlIGFyZSBpbnRlcm5hbCByZWZlcmVuY2VzIHRvIHRoZSBiZWxvd21lbnRpb25lZCBidWlsZHMgaW4gbXkgY29tbXVuaXR5LiBJZiB5b3Ugd2lzaCB0byB1bmRlcnN0YW5kIGl0IGJldHRlciwgaG93IGFib3V0IGdpdmluZyBpdCBhIHZpc2l0Pw0KDQokaXNrdXNhbmFsaWhlcmUgPSAoR2V0LUl0ZW1Qcm9wZXJ0eSAtUGF0aCAiSEtDVTpcU29mdHdhcmVcQXV0b0lES1UiIC1FcnJvckFjdGlvbiBTaWxlbnRseUNvbnRpbnVlKS5MZXNzZXJMb3JkS3VzYW5hbGkNCmlmICgkaXNrdXNhbmFsaWhlcmUgLWxpa2UgIk5haGlkYSIpIHsNCglpZiAoJGJ1aWxkIC1lcSAxOTA0MSkgew0KCQlXcml0ZS1Ib3N0ICJXZWxjb21lIHRvICIgLUZvcmVncm91bmRDb2xvciBXaGl0ZSAtbjsgV3JpdGUtSG9zdCAiRVRFUk5JVFkiIC1Gb3JlZ3JvdW5kQ29sb3IgQmxhY2sgLUJhY2tncm91bmRDb2xvciBCbHVlDQoJfSBlbHNlaWYgKCRidWlsZCAtZXEgMTc2OTIpIHsNCgkJV3JpdGUtSG9zdCAiQnkgdGhlIHdheSwgZ29vZCB0byBzZWUgeW91ICIgLUZvcmVncm91bmRDb2xvciBXaGl0ZSAtbjsgV3JpdGUtSG9zdCAiU2V0c3VuYSIgLUZvcmVncm91bmRDb2xvciBCbGFjayAtQmFja2dyb3VuZENvbG9yIFllbGxvdw0KCX0gZWxzZWlmICgkYnVpbGQgLWVxIDIwMzQ4KSB7DQoJCVdyaXRlLUhvc3QgIldhaXQuLi4gd2hhdD8gIiAtRm9yZWdyb3VuZENvbG9yIFdoaXRlIC1uOyBXcml0ZS1Ib3N0ICJNYW5uZW56YWt1cmE/Pz8iIC1Gb3JlZ3JvdW5kQ29sb3IgV2hpdGUgLUJhY2tncm91bmRDb2xvciBNYWdlbnRhDQoJfSBlbHNlIHt9DQp9DQoNCiMgVGhlcmUncyBzdGlsbCBtb3JlIHRvIGJlIGRpc2NvdmVyZWQuLi4gR29vZCBsdWNrISA8MyBmcm9tIEJpb25pYyBCdXR0ZXIuDQo=")) | Out-File -FilePath $workdir\modules\lib\PrintEdition.ps1

# Create registry folder
$autoidku = Test-Path -Path 'HKCU:\SOFTWARE\AutoIDKU'
if ($autoidku -eq $false) {
	New-Item -Path 'HKCU:\SOFTWARE' -Name AutoIDKU | Out-Null
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "BootStrapped" -Value 0 -Type DWord -Force
}

# Find the build number, UBR, and OS architecture of the system
# This script runs best on General Availability builds between 10240 and 19045. You can of course modify the lines below for it to run on untested builds, although stability might suffer and I will not be providing support for those scenarios.
# Your system must also be running a 64-bit OS.
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Checking your PC"
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
$gablds = 10240,10586,14393,15063,16299,17134,17763,18362,18363,19041,19042,19043,19044,19045
switch ($build) {
	{$_ -ge 10240 -and $_ -le 21390 -and $_ -ne 20348} {
		if ($gablds.Contains($_) -eq $true) {
			Write-Host "Supported stable build of Windows 10 detected" -ForegroundColor Green -BackgroundColor DarkGray
			Show-Edition
		} else {
			Write-Host "Your Windows 10 build appears to be in the supported range, but doesn't seem to be a General Availability build. `r`nStability might suffer and I will not be providing support for issues happening on such builds." -ForegroundColor Yellow -BackgroundColor DarkGray
			Show-Edition
			$ngawarn = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).SkipNotGABWarn
			if ($ngawarn -ne 1) {
				Write-Host "Press Enter to continue."; Read-Host
				Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "SkipNotGABWarn" -Value 1 -Type DWord -Force
			}
		}
	}
	{$_ -eq 20348} {
		Write-Host "Supported stable build of Windows 10 detected" -ForegroundColor Green -BackgroundColor DarkGray
		Show-Edition
	}
	default {
		Write-Host "You're not running a supported build of Windows for this script. Press Enter to exit." -ForegroundColor Red -BackgroundColor DarkGray
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 1 -Type DWord -Force
		Read-Host
		exit
	}
}
. $workdir\modules\lib\getedition.ps1
Write-Host "You're running Windows $editiond, OS build"$build"."$ubr

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
if ($build -le 10586) {
	Write-Host " "
	Set-AutoIDKUValue d "Pwsh" 5
}
if ($build -ge 14393) {
	Write-Host " "
	Set-AutoIDKUValue d "Pwsh" 7
}
Set-AutoIDKUValue d "ConfigSet" 0
Set-AutoIDKUValue d "ConfigEditing" 0 
Set-AutoIDKUValue d "ConfigEditingSub" 0 
Set-AutoIDKUValue d "ChangesMade" 0
Set-AutoIDKUValue d "Denied" 0
Set-AutoIDKUValue d "HikaruMode" 0
Set-AutoIDKUValue d "SetWallpaper" 1
Set-AutoIDKUValue d "HikaruMusic" 1
Set-AutoIDKUValue d "EssentialApps" 1
Set-AutoIDKUValue d "WUmode" 1
Set-AutoIDKUValue d "EdgeKilled"  0
Set-AutoIDKUValue d "PendingRebootCount" 0
Set-AutoIDKUValue d "RunningThisRemotely" 0
Set-AutoIDKUValue d "ClearBootMessage" 0
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue

if ($edition -like "Core") {
	Write-Host " "
	Write-Host "Home edition detected" -ForegroundColor Black -BackgroundColor Yellow
	Write-Host "Beware that certain system restrictions, like blocking Feature updates in Windows Update will NOT work with this edition." -ForegroundColor Yellow -BackgroundColor DarkGray
	Start-Sleep -Seconds 3
	Write-Host " "
}
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

# Get Hikaru
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Getting dependencies ready"
Start-Process powershell -Wait -ArgumentList "-Command $workdir\utils\hikarug.ps1" -WorkingDirectory $workdir\utils

# Immediately install the ambient sound package and play the script startup sound
Expand-Archive -Path $workdir\utils\ambient.zip -DestinationPath $coredir\ambient
Start-Process "$coredir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $coredir\ambient\SpiralAbyss.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue
Set-AutoIDKUValue d "BootStrapped" 1
exit
