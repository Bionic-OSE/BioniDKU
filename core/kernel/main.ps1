# BioniDKU main orchestrator file - (c) Bionic Butter

##############################################################
# Declare basic functions
function Show-Branding($s1) {
	if ($s1 -like "clear") {Clear-Host}
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "$releasetype - $butter" -ForegroundColor Black -BackgroundColor White
	Write-Host " "
}
function Get-ScriptProgress($value) {
	$proc = Get-Content -Path $datadir\values\progress.txt
	$valnt = [int32]$value
	$pg = [Math]::Round(($valnt / 24) * 100) 
	# Currently we have a maximum of 23 actions, taking that +1 so action 23 won't become 100%
	Show-WindowTitle 3 $pg
	return [int32]$proc -le $valnt
}
Set-Alias -Name SPV -Value Get-ScriptProgress # SPV = Script Progress Value
function Set-ScriptProgress($value) {[int32]$value | Out-File -FilePath $datadir\values\progress.txt}
Set-Alias -Name UPV -Value Set-ScriptProgress # UPV = Update Progress Value
# UPV always = SPV + 1!!!

# Grab neccessary variables, then set the Working directory, Core folder's directory and Data folder's directory
$global:releasetype = (Get-ItemProperty -Path "HKCU:\Software\BioniDKU").ReleaseType
$global:butter = (Get-ItemProperty -Path "HKCU:\Software\BioniDKU").ReleaseIDEx
$global:pwsh = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Pwsh
$global:workdir = Split-Path(Split-Path "$PSScriptRoot")
$global:coredir = Split-Path "$PSScriptRoot"
$global:datadir = "$workdir\data"

# Load modules, values and configurations from files
. $coredir\kernel\osinfo.ps1
. $coredir\kernel\config.ps1
Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Titlebar.psm1
Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Logging.psm1
Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Ambient.psm1

# This is for the script to just display the final message if it was started after a successful run
$cmpstat = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ALLCOMPLETED
if ($cmpstat -eq 16384) {
	& $coredir\support\notefinish.ps1 1
	exit
}

# Main menu section
$confuled = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ConfigSet
if ($confuled -eq 0 -or $confuled -eq 2) {Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 3 -Type DWord -Force}
while ($true) {
	$confuled = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ConfigSet
	if ($confuled -eq 0 -or $confuled -eq 1 -or $confuled -eq 2) {break} else {& $coredir\kernel\menu.ps1}
}

if ($confuled -eq 2) {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 3 -Type DWord -Force
	exit
}
elseif ($confuled -eq 0) {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 0 -Type DWord -Force
	exit
}

##############################################################


######################## BEGIN SCRIPT ########################

# Show branding
Show-WindowTitle 3 0 noclose
Start-Logging NormalMode_MainWindow
Show-Branding clear
Write-OSInfo

# Remove startup obstacles while in Hikaru mode 1, then switch back to mode 0
. $coredir\kernel\minihikaru.ps1
$hkm = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMode
if ($hkm -eq 1) {
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Switching to normal mode"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value 'explorer.exe' -Type String
	Set-HikaruChan
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing startup obstacles"
	& $workdir\modules\removal\letsNOTfinish.ps1
	if ($build -ge 18362 -and $build -le 19041) {
		Start-Process powershell -ArgumentList "-Command $workdir\modules\removal\edgekiller.ps1"
		Start-Sleep -Seconds 3
	} if ($build -ge 18362) {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling App Dark Mode, forcing Dark Taskbar"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 1 -Type DWord -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Value 0 -Type DWord -Force
	}
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 0 -Type DWord -Force
}
$isexplorerup = Get-Process -Name explorer -ErrorAction SilentlyContinue
if ($hkm -eq 1 -or -not $isexplorerup) {
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Starting Windows Explorer"
	Play-Ambient 6
	Start-HikaruShell
	$wasexplorerup = $false
} else {$wasexplorerup = $true}

# Continue importing values
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Initializing environment"

$pendingreboot = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending')
$pendingrebootcount = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").PendingRebootCount
if ($pendingreboot -eq $true) {
	if ($pendingrebootcount -gt 3) {
		Write-Host -ForegroundColor Black -BackgroundColor Yellow "Your PC have queued a restart more than 3 times!"
		Write-Host -ForegroundColor Yellow "This is likely due to Windows Update being busy at the moment. I suggest checking the page in Settings for any on-going updates, or check in Task Manager for any WU-related processes and wait for them to finish if possible."
		Write-Host -ForegroundColor White "If you wish to continue the script despite the pending restart, press Enter twice. Otherwise, please restart the system manually (the script will automatically resume when you do so)."
		Read-Host
		Read-Host
	} elseif (SPV 0) {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Your PC has a pending restart, which has to be done before running this script. Automatically restarting in 5 seconds..."
		$pendingrebootcounting = $pendingrebootcount + 1
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "PendingRebootCount" -Value $pendingrebootcounting -Type DWord -Force
		Start-Sleep -Seconds 5
		Restart-System
	}
}
$setupmusic = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic
$ngawarn = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SkipNotGABWarn
$essentialapps = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).EssentialApps


# NOW WE GET TO THE REAL BUSINESS

if ($setupmusic -eq 1) {
	if ($wasexplorerup -eq $false) {Write-Host "Starting Music player in the background" -BackgroundColor DarkGray -ForegroundColor Cyan; Start-Process powershell -WindowStyle Hidden -ArgumentList "-Command $coredir\music\musicplayer.ps1"}
	$setupmusicend = "/after the currently playing song ends, whichever comes first"
} else {$setupmusicend = $null}

if (SPV 0) {$startmsg = "begins"} else {$startmsg = "continues"}
Show-WindowTitle
Write-Host -ForegroundColor Black -BackgroundColor Cyan "`r`nThe IDKUlize process ${startmsg}"

# Action 1 (I will just say "A1, A2..." from now)
if ($build -lt 17134 -and (SPV 1)) {& $workdir\modules\removal\unsealtheclasses.ps1; UPV 2}
$firefox = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").Firefox

switch ($true) {

	# A2
	{$dotnet35 -and (SPV 2)} {
		switch ($true) {
			{$ngawarn -eq 1} {
				Write-Host -ForegroundColor Black -BackgroundColor Red "Failed to enable .NET 3.5"
				Write-Host -ForegroundColor Red "Due to the nature of non-General-Availability builds, this cannot be done automatically."
				Write-Host -ForegroundColor White "To enable .NET 3.5, you need to mount the VANILLA installation media of this build, and run the following command (assuming D:\ is where it's mounted at):"
				Write-Host -ForegroundColor Yellow "   DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /Source:D:\sources\sxs /LimitAccess"
				Write-Host " "
			}
			{$edition -like "EnterpriseG"} {
				Write-Host -ForegroundColor Black -BackgroundColor Red "Failed to enable .NET 3.5"
				Write-Host -ForegroundColor Red "Due to the limitations of CMGE editions, this cannot be done automatically."
				Write-Host -ForegroundColor White "To enable .NET 3.5, you need to mount the VANILLA installation media of a different edition of the same build, and run the following command (assuming D:\ is where it's mounted at):"
				Write-Host -ForegroundColor Yellow "   DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /Source:D:\sources\sxs /LimitAccess"
				Write-Host " "
			}
			default {
				Write-Host "Enabling .NET 3.5" -ForegroundColor Cyan -BackgroundColor DarkGray
				Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All -NoRestart
			}
		}
		UPV 3
	}

	# A3
	{$dotnet462 -and (SPV 3)} {
		UPV 4; Write-Host "Installing .NET 4.6.2" -ForegroundColor Cyan -BackgroundColor DarkGray
		Write-Host -ForegroundColor Cyan "`r`nUntil .NET finishes the installation and automatically restarts the system, please DO NOT:"
		Write-Host -ForegroundColor Cyan "- Try to stop the installation process"
		Write-Host -ForegroundColor Cyan "- Restart the computer manually (unless if it doesn't do so automatically)"
		Start-Process $datadir\dls\dotnet462.exe -NoNewWindow -Wait -ArgumentList "/passive /log %temp%\net.htm"
		Start-Sleep -Seconds 30
		Read-Host
	}

	# A4
	{$firefox -eq 1 -and (SPV 4)} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing Mozilla Firefox ESR" -n; Write-Host -ForegroundColor White " (right now, as we will need it for the next part)"
		Start-Process $datadir\dls\firefoxesr.exe -Wait -NoNewWindow -ArgumentList "/S /PrivateBrowsingShortcut=false /PreventRebootRequired=true /TaskbarShortcut=false"
		UPV 5
	}
	
}

# A5
if (SPV 5) {& $coredir\support\manualstuffs.ps1; UPV 6}

switch ($true) {
	
	default {exit}

	# Taskbar and desktop zone

	# A6
	{$hidetaskbaricons -and (SPV 6)} {
		& $workdir\modules\desktop\hidetaskbaricons.ps1; UPV 7
	}

	# A7
	{$taskbarpins -and (SPV 7)} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing pinned items from taskbar"
		Stop-Process -Name "explorer" -Force 
		Remove-Item "$env:appdata\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*" -Force -Recurse
		Start-Process explorer.exe
		UPV 8
	}

	# A8
	{$explorericon -and (SPV 8)} {
		& $workdir\modules\desktop\explorericon.ps1; UPV 9
	}

	# A9
	{$removedownloads -and (SPV 9)} {
		& $workdir\modules\desktop\dlreplacement.ps1; UPV 10
	}

	# A10
	{$removeedgeshortcut -and (SPV 10)} {
		& $workdir\modules\removal\removeedgeshortcut.ps1; UPV 11
	}

	# A11
	{$desktopshortcuts -and (SPV 11)} {
		& $workdir\modules\desktop\desktopshortcuts.ps1; UPV 12
	}

	# Installation zone

	# A12
	{$essentialapps -eq 1 -and (SPV 12)} {
		& $workdir\modules\essential\essentialapps.ps1; UPV 13
	}

	# Destruction zone

	# A13
	{$removeonedrive -and (SPV 13)} {
		& $workdir\modules\removal\removeonedrive.ps1; UPV 14
	}

	# A14
	{$removewaketimers -and (SPV 15)} {
		Write-Host "Disabling Wake Timers" -BackgroundColor DarkGray -ForegroundColor Cyan
		powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0
		if ($null -ne $battery) {
			powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0
		}
		UPV 15
	}

	# A15
	{$replaceemojifont -and (SPV 15)} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Replacing Segoe UI Emoji Font with the one from Windows 11 build 23475"
		Copy-Item -Path $datadir\utils\seguiemj11.ttf -Destination $env:SYSTEMDRIVE\Windows\Fonts\seguiemj11.ttf
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Segoe UI Emoji (TrueType)" -Value "seguiemj11.ttf" -Type String -Force
		UPV 16
	}

	# A16
	{$removehomegroup -and $build -lt 17134 -and (SPV 16)} {
		& $workdir\modules\removal\removehomegroup.ps1; UPV 17
	}

	# A17
	{$registrytweaks -and (SPV 17)} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Applying Registry tweaks"
		& $workdir\modules\essential\simpleregistry.ps1; UPV 18
	}

	# A18
	{$embeddedlogon -and $build -ge 14393 -and (SPV 18)} {
		& $workdir\modules\desktop\embeddedlogon.ps1; UPV 19
	}

	# A19
	{$removeUWPapps -and (SPV 19)} {
		# On certain builds, there is a freeze issue where the script will just hang here forever, we have to use another method...
		Start-Process $coredir\7z\7za.exe -Wait -NoNewWindow -ArgumentList "x $datadir\utils\SuwakoDebloaterLite-Bionic.7z -o$datadir\utils\SuwakoDebloaterLite-Bionic -aoa"
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing all UWP apps possible"
		Write-Host -ForegroundColor Cyan "DO NOT CLOSE THE OPENED WINDOW!"
		Write-Host -ForegroundColor Cyan "This process will spit out of errors, and that is normal."
		Write-Host -ForegroundColor Cyan "In addition, it will also create a repeatedly flashing console HUD. If you are sensitive to flashes, please minimize or do not look at that window."
		if (-not $keepedgechromium -and $build -ge 17763) {$keepedgeparam = '$true $true'} else {$keepedgeparam = '$false $false'}
		$suwakoparam = "& $datadir\utils\SuwakoDebloaterLite-Bionic\Scripts\Remove-Runner.ps1" + ' $true $true $true $true ' + $keepedgeparam + '; Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name UWPAppsRemoved" -Value 1 -Type DWord -Force'
		Start-Process powershell -ArgumentList $suwakoparam
		while ($true) {
			$suwakodone = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").UWPAppsRemoved
			if ($suwakodone -eq 1) {break}
			Start-Sleep -Seconds 1
		}
		UPV 20
	}

	# A20
	{$sltoshutdownwall -and (SPV 20)} {
		& $workdir\modules\desktop\slidetoshutdownwall.ps1; UPV 21
	}

	# A21
	{$customsounds -and (SPV 21)} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing custom system sounds" 
		Start-Process powershell -Wait -ArgumentList "$workdir\modules\desktop\customsounds.ps1"
		UPV 22
	}

	# A22
	{$removesystemapps -and (SPV 22)} {
		# Same as A19
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling system apps" 
		Start-Process powershell -ArgumentList "$workdir\modules\removal\removesystemapps.ps1"
		while ($true) {
			$sappdone = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SystemAppsRemoved
			if ($sappdone -eq 1) {break}
			Start-Sleep -Seconds 1
		}
		UPV 23
	}

	# A23
	{$thinneraddressbar -and (SPV 23)} {
		& $workdir\modules\desktop\addressbartweaks.ps1 1; UPV 24
	}

}

# This the last action, and must not be interrupted.
Show-WindowTitle 3 99 noclose
& $coredir\support\hikarinstall.ps1 

# Finalize things, and the job ends!
if ($build -le 14393 -and $balloonnotifs -eq $false) {
	Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'EnableLegacyBalloonNotifications' -Value 0 -Type DWord -Force
}
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ALLCOMPLETED" -Value 16384 -Type DWord -Force 

Write-Host " "
Show-WindowTitle 3 100
Start-Process powershell -WindowStyle Hidden -ArgumentList "-Command $coredir\support\noterestart.ps1"
Write-Host "This was the final step of the script." -ForegroundColor Black -BackgroundColor Green
Write-Host "In order to complete the operation, please press Enter to restart." -ForegroundColor Green
Write-Host "(Or the device will restart after 60 seconds${setupmusicend})." -ForegroundColor Green
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMusicStop" -Value 1 -Type DWord -Force
Play-Ambient 8
& $coredir\support\notefinish.ps1 0
Restart-System
