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
$releaseid = "22107.300_update1"
$releaseidex = "22107.300_update1.oseprod_mainrel.230528-1456"

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
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("IyBDb25ncmF0dWxhdGlvbnMsIHlvdSBoYXZlIGZvdW5kIHRoZSBmaXJzdCB0d28gZWFzdGVyIGVnZ3MgaW4gQmlvbmlES1UgKHRoZSBvdGhlciBvbmUgYmVpbmcgdGhlIGNodW5rIG9mIEJhc2U2NCBjb2RlIGJlbG93IHRoaXMgb25lKS4NCiMgTW9zdCBvZiB5b3UgZm9yIHN1cmUgd2lsbCBub3QgZ2V0IHdoYXQgdGhlc2UgbWVhbnMsIGFuZCB0aGF0J3MgZmluZSwgaXQncyBub3QgcmVhbGx5IGZvciB5b3UuIExvbmcgc3Rvcnkgc2hvcnQsIHRoZXNlIGFyZSBpbnRlcm5hbCByZWZlcmVuY2VzIHRvIHRoZSBiZWxvd21lbnRpb25lZCBidWlsZHMgaW4gbXkgY29tbXVuaXR5LCBhbmQgb25seSB0aG9zZSB3aG8ncmUgaW4gdGhlIGNvbW11bml0eSBjYW4gdW5kZXJzdGFuZCB0aGVtLiBVbmZvcnR1bmF0ZWx5IHRoaXMgY29tbXVuaXR5IGlzIHByaXZhdGUsIHNvIHRoZXJlJ3Mgbm90aGluZyBlbHNlIHlvdSBjYW4gbGVhcm4gYWJvdXQgdGhlc2UuDQojIFNvIHdoeSBkaWQgSSBkZWNpZGUgdG8gcHV0IHRoZXNlIGluIGEgY2h1bmsgb2YgQmFzZTY0IGluIE5hbmEsIGFuZCBub3QgaW4gYW4gYWN0dWFsIGZpbGU/IFdlbGwuLi4gaXQncyB0byBoaWRlIGZyb20gdGhlIGdlbmVyYWwgcHVibGljLCBzaW5jZSBwdXR0aW5nIHRoZXNlIHdlaXJkIHJlZmVyZW5jZXMgaW4gcGxhaW4gdGV4dCBtaWdodCBtYWtlIHRoZW0gc291bmQuLi4gc3RyYW5nZSB0byBwZW9wbGUuDQoNCiRpc2t1c2FuYWxpaGVyZSA9IChHZXQtSXRlbVByb3BlcnR5IC1QYXRoICJIS0NVOlxTb2Z0d2FyZVxBdXRvSURLVSIgLUVycm9yQWN0aW9uIFNpbGVudGx5Q29udGludWUpLkxlc3NlckxvcmRLdXNhbmFsaQ0KaWYgKCRpc2t1c2FuYWxpaGVyZSAtbGlrZSAiTmFoaWRhIikgew0KCWlmICgkYnVpbGQgLWVxIDE5MDQxKSB7DQoJCVdyaXRlLUhvc3QgIldlbGNvbWUgdG8gIiAtRm9yZWdyb3VuZENvbG9yIFdoaXRlIC1uOyBXcml0ZS1Ib3N0ICJFVEVSTklUWSIgLUZvcmVncm91bmRDb2xvciBCbGFjayAtQmFja2dyb3VuZENvbG9yIEJsdWUNCgl9IGVsc2VpZiAoJGJ1aWxkIC1lcSAxNzY5Mikgew0KCQlXcml0ZS1Ib3N0ICJCeSB0aGUgd2F5LCBnb29kIHRvIHNlZSB5b3UgIiAtRm9yZWdyb3VuZENvbG9yIFdoaXRlIC1uOyBXcml0ZS1Ib3N0ICJTZXRzdW5hIiAtRm9yZWdyb3VuZENvbG9yIEJsYWNrIC1CYWNrZ3JvdW5kQ29sb3IgWWVsbG93DQoJfSBlbHNlaWYgKCRidWlsZCAtZXEgMjAzNDgpIHsNCgkJV3JpdGUtSG9zdCAiV2FpdC4uLiB3aGF0PyAiIC1Gb3JlZ3JvdW5kQ29sb3IgV2hpdGUgLW47IFdyaXRlLUhvc3QgIk1hbm5lbnpha3VyYT8/PyIgLUZvcmVncm91bmRDb2xvciBXaGl0ZSAtQmFja2dyb3VuZENvbG9yIE1hZ2VudGENCgl9IGVsc2Uge30NCn0NCg0KIyBUaGVyZSdzIHN0aWxsIG1vcmUgdG8gYmUgZGlzY292ZXJlZC4uLiBHb29kIGx1Y2shIDwzIGZyb20gQmlvbmljIEJ1dHRlci4NCg==")) | Out-File -FilePath $workdir\modules\lib\PrintEdition.ps1
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("IyBUaGlzIGlzIHRoZSBzZWNvbmQgcGllY2Ugb2YgZWFzdGVyIGVnZyBpbiBCaW9uaURLVSwgYXNzdW1pbmcgeW91J3ZlIGNvbnZlcnRlZCB0aGUgZmlyc3Qgb25lIA0KDQokaXNrdXNhbmFsaWhlcmUgPSAoR2V0LUl0ZW1Qcm9wZXJ0eSAtUGF0aCAiSEtDVTpcU29mdHdhcmVcQXV0b0lES1UiIC1FcnJvckFjdGlvbiBTaWxlbnRseUNvbnRpbnVlKS5MZXNzZXJMb3JkS3VzYW5hbGkNCiRoZWxsID0gKEdldC1JdGVtUHJvcGVydHkgLVBhdGggIkhLQ1U6XFNvZnR3YXJlXEF1dG9JREtVIikuV2VsY29tZVRvSGVsbA0KaWYgKCRoZWxsIC1lcSAxIC1hbmQgJGhrYXUgLWVxIDEgLWFuZCAkaXNrdXNhbmFsaWhlcmUgLWxpa2UgIk5haGlkYSIpIHsNCglTdGFydC1Qcm9jZXNzIHBvd2Vyc2hlbGwgLVdpbmRvd1N0eWxlIEhpZGRlbiAtV2FpdCAtQXJndW1lbnRMaXN0ICItQ29tbWFuZCAkd29ya2RpclxtdXNpY1xtdXNpY3IucHMxIiAtV29ya2luZ0RpcmVjdG9yeSAkd29ya2RpclxtdXNpYw0KCXRhc2traWxsIC9mIC9pbSBXaW5YU2hlbGwuZXhlDQoJU2V0LUl0ZW1Qcm9wZXJ0eSAtUGF0aCAiSEtDVTpcU29mdHdhcmVcQXV0b0lES1UiIC1OYW1lICJIaWthcnVNdXNpY1N0b3AiIC1WYWx1ZSAxIC1UeXBlIERXb3JkIC1Gb3JjZQ0KCVN0YXJ0LVNsZWVwIC1TZWNvbmRzIDENCgl0YXNra2lsbCAvZiAvaW0gRkZQbGF5LmV4ZQ0KCVN0YXJ0LVNsZWVwIC1TZWNvbmRzIDMNCglSZW5hbWUtSXRlbSAtUGF0aCAiJGVudjpTWVNURU1EUklWRVxCaW9uaWNcV2luWFNoZWxsXGJhY2tncm91bmQuanBnIiAtTmV3TmFtZSAib2xkZ3JvdW5kLmpwZyINCglTdGFydC1Qcm9jZXNzICRjb3JlZGlyXDd6YS5leGUgLVdhaXQgLVdpbmRvd1N0eWxlIEhpZGRlbiAtQXJndW1lbnRMaXN0ICJlICR3b3JrZGlyXHV0aWxzXHN0YXR1ZW9mNi43eiAtcFdFTENPTUVUT0hFTEwgLW8kd29ya2Rpclx1dGlscyINCglDb3B5LUl0ZW0gLVBhdGggIiR3b3JrZGlyXHV0aWxzXGhlbGxncm91bmQuanBnIiAtRGVzdGluYXRpb24gIiRlbnY6U1lTVEVNRFJJVkVcQmlvbmljXFdpblhTaGVsbFxiYWNrZ3JvdW5kLmpwZyINCglXcml0ZS1Ib3N0ICIgIjsgV3JpdGUtSG9zdCAiMTYwNyBkZXRlY3RlZC4gIiAtbjsgV3JpdGUtSG9zdCAtRm9yZWdyb3VuZENvbG9yIEJsYWNrIC1CYWNrZ3JvdW5kQ29sb3IgUmVkICJXRUxDT01FIFRPIEhFTEwiDQoJUmVuYW1lLUl0ZW0gLVBhdGggIiRlbnY6U1lTVEVNRFJJVkVcQmlvbmljXEhpa2FydVxBZHZhbmNlZFJ1bi5leGUiIC1OZXdOYW1lICJBZHZhbmNlZFJ1bi5ESVNBQkxFRCINCglTdGFydC1Qcm9jZXNzICIkZW52OlNZU1RFTURSSVZFXEJpb25pY1xXaW5YU2hlbGxcV2luWFNoZWxsLmV4ZSINCglTdGFydC1Qcm9jZXNzIHBvd2Vyc2hlbGwgLUFyZ3VtZW50TGlzdCAiLUNvbW1hbmQgJHdvcmtkaXJcbXVzaWNcbXVzaWNwbGF5ZXIucHMxIg0KCVN0YXJ0LVNsZWVwIC1TZWNvbmRzIDYNCglNb3ZlLUl0ZW0gLVBhdGggIiRlbnY6U1lTVEVNRFJJVkVcQmlvbmljXFdpblhTaGVsbFxvbGRncm91bmQuanBnIiAtRGVzdGluYXRpb24gIiRlbnY6U1lTVEVNRFJJVkVcQmlvbmljXFdpblhTaGVsbFxiYWNrZ3JvdW5kLmpwZyIgLUZvcmNlDQoJUmVuYW1lLUl0ZW0gLVBhdGggIiRlbnY6U1lTVEVNRFJJVkVcQmlvbmljXEhpa2FydVxBZHZhbmNlZFJ1bi5ESVNBQkxFRCIgLU5ld05hbWUgIkFkdmFuY2VkUnVuLmV4ZSINCglTZXQtSXRlbVByb3BlcnR5IC1QYXRoICJIS0NVOlxTb2Z0d2FyZVxBdXRvSURLVSIgLU5hbWUgIldlbGNvbWVUb0hlbGwiIC1WYWx1ZSAwIC1UeXBlIERXb3JkIC1Gb3JjZQ0KCVNldC1JdGVtUHJvcGVydHkgLVBhdGggIkhLQ1U6XFNvZnR3YXJlXEF1dG9JREtVIiAtTmFtZSAiY1dVZmlybSIgLVZhbHVlIDAgLVR5cGUgRFdvcmQgLUZvcmNlDQp9DQoNCiMgVGhlcmUncyBzdGlsbCBtb3JlIHRvIGJlIGRpc2NvdmVyZWQuLi4gR29vZCBsdWNrISA8MyBmcm9tIEJpb25pYyBCdXR0ZXIuDQo=")) | Out-File -FilePath $workdir\modules\essential\cWUngun.ps1
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("IyBUaGlzIGlzIG5vdCByZWFsbHkgYW4gZWFzdGVyIGVnZy4gSXQncyBhbiBvbGQgZmVhdHVyZSwgYnV0IEkganVzdCBkb24ndCB3YW50IHRvIHRocm93IGl0IGF3YXksIHNvIG1ha2luZyBpdCBhIHNlY3JldCBpbnN0ZWFkLg0KDQokaXNrdXNhbmFsaWhlcmUgPSAoR2V0LUl0ZW1Qcm9wZXJ0eSAtUGF0aCAiSEtDVTpcU29mdHdhcmVcQXV0b0lES1UiIC1FcnJvckFjdGlvbiBTaWxlbnRseUNvbnRpbnVlKS5MZXNzZXJMb3JkS3VzYW5hbGkNCmlmICgkaXNrdXNhbmFsaWhlcmUgLW5vdGxpa2UgIk5haGlkYSIpIHtleGl0fQ0KDQpXcml0ZS1Ib3N0IC1Gb3JlZ3JvdW5kQ29sb3IgQ3lhbiAtQmFja2dyb3VuZENvbG9yIERhcmtHcmF5ICJZb3VyIGJ1aWxkIGRvZXMgbm90IHN1cHBvcnQgV2luZG93cyBVcGRhdGUgdGhyb3VnaCBQb3dlclNoZWxsLiBIYXZlIHlvdSBmdWxseSB1cGRhdGVkIHlldD8gKFllcyBpcyBkZWZhdWx0IGFuc3dlcikiDQppZiAoJGJ1aWxkIC1lcSAxMDI0MCAtYW5kICRkaXNhYmxlbG9ja3Njcm4pIHtXcml0ZS1Ib3N0ICJPbiBXaW5kb3dzIDEwIGJ1aWxkIDEwMjQwLCB1cGRhdGluZyBpcyAiIC1uOyBXcml0ZS1Ib3N0ICJSRVFVSVJFRCIgLUZvcmVncm91bmRDb2xvciBCbGFjayAtQmFja2dyb3VuZENvbG9yIFllbGxvdyAtbjsgV3JpdGUtSG9zdCAiIGluIG9yZGVyIHRvIGJlIGFibGUgdG8gZGlzYWJsZSB0aGUgTG9nb25VSSdzIGJhY2tncm91bmQuIn0NCldyaXRlLUhvc3QgIllvdXIgYW5zd2VyOiAiIC1uIDsgJGZ1bGx5dXBkYXRlZCA9IFJlYWQtSG9zdA0Kc3dpdGNoICgkZnVsbHl1cGRhdGVkKSB7DQoJeyRmdWxseXVwZGF0ZWQgLWxpa2UgIm5vIn0gew0KCQlXcml0ZS1Ib3N0IC1Gb3JlZ3JvdW5kQ29sb3IgUmVkIC1CYWNrZ3JvdW5kQ29sb3IgRGFya0dyYXkgIlRoZW4gdGhlIHNjcmlwdCBmZWxsIGludG8gZGFya25lc3MuIg0KCQlTdGFydC1TbGVlcCAtU2Vjb25kcyA1DQoJfQ0KCXskZnVsbHl1cGRhdGVkIC1saWtlICcqZnVjayonfSB7DQoJCVdyaXRlLUhvc3QgLUZvcmVncm91bmRDb2xvciBSZWQgLUJhY2tncm91bmRDb2xvciBEYXJrR3JheSAiSEFILCBMIg0KCQlTdGFydC1TbGVlcCAtU2Vjb25kcyA1DQoJfQ0KCXskZnVsbHl1cGRhdGVkIC1saWtlICdKdWxpYSBsb3ZlcyBSVE0nfSB7DQoJCVdyaXRlLUhvc3QgLUZvcmVncm91bmRDb2xvciBSZWQgLUJhY2tncm91bmRDb2xvciBEYXJrR3JheSAiWWVzIGFic29sdXRlbHkiDQoJCVN0YXJ0LVNsZWVwIC1TZWNvbmRzIDINCgkJV3JpdGUtSG9zdCAtRm9yZWdyb3VuZENvbG9yIFJlZCAtQmFja2dyb3VuZENvbG9yIERhcmtHcmF5ICJXYWl0LCB3aG8gYXNrZWQ/IFJlYWQgdGhlIHF1ZXN0aW9uIGFnYWluIHlvdSBibGluZC4iDQoJCVN0YXJ0LVNsZWVwIC1TZWNvbmRzIDMNCgl9DQoJZGVmYXVsdCB7DQoJCVdyaXRlLUhvc3QgLUZvcmVncm91bmRDb2xvciBHcmVlbiAiQ29vbCEiDQoJCWV4aXQNCgl9DQp9DQoNCldyaXRlLUhvc3QgIiAiDQpXcml0ZS1Ib3N0IC1Gb3JlZ3JvdW5kQ29sb3IgR3JlZW4gIkpva2VzIGFzaWRlLCBJIGtub3cgeW91J3JlIGZ1bGx5IHVwZGF0ZWQuIEkgbWVhbiB5b3Ugd291bGRuJ3QgaGF2ZSBiZWVuIGFibGUgdG8gZXZlbiBzZWUgdGhhdCBxdWVzdGlvbiBpZiB5b3UgaGF2ZW4ndCBhbnl3YXlzLi4uIg0K")) | Out-File -FilePath $workdir\core\kernel\confirmwupdated.ps1

# Create registry folder
$autoidku = Test-Path -Path 'HKCU:\SOFTWARE\AutoIDKU'
if ($autoidku -eq $false) {
	New-Item -Path 'HKCU:\SOFTWARE' -Name AutoIDKU | Out-Null
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "BootStrapped" -Value 0 -Type DWord -Force
}

# Find the Windows edition, build number, UBR, and OS architecture of the system
# This script runs best on General Availability builds between 10240 and 19045. You can of course modify the lines below for it to run on untested builds, although stability might suffer and I will not be providing support for those scenarios.
# Your system must also be running a 64-bit OS.
# Support for Server edition is currently experimental, and Server Core installations are not supported.
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
$gablds = 10240,10586,14393,15063,16299,17134,17763,18362,18363,19041,19042,19043,19044,19045,20348
. $workdir\modules\lib\getedition.ps1
switch ($build) {
	{$_ -ge 10240 -and $_ -le 21390} {
		if ($gablds.Contains($_) -eq $true) {
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
switch ($editon) {
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
	Set-AutoIDKUValue d "WUmodeSwitch" 0
}
if ($build -ge 14393) {
	Write-Host " "
	Set-AutoIDKUValue d "Pwsh" 7
	Set-AutoIDKUValue d "WUmodeSwitch" 1
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
Set-AutoIDKUValue d "EdgeKilled"  0
Set-AutoIDKUValue d "PendingRebootCount" 0
Set-AutoIDKUValue d "RunningThisRemotely" 0
Set-AutoIDKUValue d "ClearBootMessage" 0
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
