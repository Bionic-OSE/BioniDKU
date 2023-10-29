# BioniDKU main orchestrator file - (c) Bionic Butter

##############################################################
# Import basic functions and grab some neccessary variables
$releasetype = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ReleaseType
$butter = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ReleaseIDEx
$pwsh = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Pwsh
function Show-Branding($s1) {
	if ($s1 -like "clear") {Clear-Host}
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "$releasetype - $butter" -ForegroundColor Black -BackgroundColor White
	Write-Host " "
}
function Stop-Script {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMusicStop" -Value 1 -Type DWord -Force
	Stop-Process -Name "FFPlay" -Force -ErrorAction SilentlyContinue
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\ShellSpinner.mp4 -fs -alwaysontop -noborder"
	Start-Sleep -Seconds 1
	exit
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

# Set Working directory, Core folder's directory and Data folder's directory
$global:workdir = Split-Path(Split-Path "$PSScriptRoot")
$global:coredir = Split-Path "$PSScriptRoot"
$global:datadir = "$workdir\data"

# Load modules, variables and configurations from file
. $coredir\kernel\config.ps1
. $workdir\modules\lib\getedition.ps1
. $workdir\modules\lib\DynamicTitlebar.ps1
$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR

# Main menu section
Show-WindowTitle 0
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
Show-Branding clear
Show-WindowTitle 3 0 noclose
Write-Host -ForegroundColor White "You're running Windows $editiontype $editiond, OS build"$build"."$ubr

# Remove startup obstacles while in Hikaru mode 1, then switch back to mode 0
. $coredir\kernel\hikaru.ps1
$hkm = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMode
if ($hkm -eq 1) {
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Switching to normal mode"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value 'explorer.exe' -Type String
	Set-HikaruChan
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing startup obstacles"
	& $workdir\modules\removal\letsNOTfinish.ps1
	if ($build -ge 18362 -and $build -le 19042) {
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
if (-not $isexplorerup) {
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Starting Windows Explorer"
	Start-HikaruShell
	$wasexplorerup = $false
} else {$wasexplorerup = $true}

# Continue importing required components
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Initializing components"

$pendingreboot = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending')
$pendingrebootcount = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").PendingRebootCount
if ($pendingreboot -eq $true) {
	if ($pendingrebootcount -gt 3) {
		Show-WindowTitle
		Write-Host -ForegroundColor Black -BackgroundColor Yellow "Your PC have queued a restart more than 3 times!"
		Write-Host -ForegroundColor Yellow "This is likely due to Windows Update being busy at the moment. I suggest checking the page in Settings for any on-going updates, or check in Task Manager for any WU-related processes and wait for them to finish if possible."
		Write-Host -ForegroundColor White "If you wish to continue the script despite the pending restart, press Enter twice. Otherwise, please restart the system manually (the script will automatically resume when you do so)."
		Read-Host
		Read-Host
		Show-WindowTitle noclose
	} else {
		Show-WindowTitle
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Your PC has a pending restart, which has to be done before running this script. Automatically restarting in 5 seconds..."
		$pendingrebootcounting = $pendingrebootcount + 1
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "PendingRebootCount" -Value $pendingrebootcounting -Type DWord -Force
		Start-Sleep -Seconds 5
		shutdown -r -t 0
		Start-Sleep -Seconds 30
		exit
	}
}
$setupmusic = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic
$ngawarn = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SkipNotGABWarn
$essentialapps = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).EssentialApps


# NOW WE GET TO THE REAL BUSINESS

if ($setupmusic -eq 1 -and $wasexplorerup -eq $false) {
	Write-Host "Starting Music player in the background" -BackgroundColor DarkGray -ForegroundColor Cyan
	Start-Process powershell -WindowStyle Hidden -ArgumentList "-Command $coredir\music\musicplayer.ps1"
}

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
		UPV 4; & $workdir\modules\apps\dotnet462install.ps1
	}

	# A4
	{$removehomegroup -and $build -lt 17134 -and (SPV 4)} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Partially removing HomeGroup"
		# First, with the permission seal removed earlier, DESTROY the key (well technically not)
		#Rename-Item "HKLM:\SOFTWARE\Classes\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}" -NewName "{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}.$build" Okay for whatever reason this is creating an undeletable HomeGroup (32-bit)
		# Then, we need to disable the service.
		Stop-Service -Name HomeGroupProvider
		Stop-Service -Name HomeGroupListener
		Start-Process sc.exe -Wait -NoNewWindow -ArgumentList "config HomeGroupProvider start= DISABLED"
		Start-Process sc.exe -Wait -NoNewWindow -ArgumentList "config HomeGroupListener start= DISABLED"
		# And all it's left is to tell the user to right click and delete the key in Explorer, done!
		UPV 5
	}

	# A5
	{$firefox -eq 1 -and (SPV 5)} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing Mozilla Firefox ESR" -n; Write-Host -ForegroundColor White " (right now, as we will need it for the next part)"
		Start-Process $datadir\dls\firefoxesr.exe -Wait -NoNewWindow -ArgumentList "/S /PrivateBrowsingShortcut=false /PreventRebootRequired=true /TaskbarShortcut=false"
		UPV 6
	}
	
}

# A6
if (SPV 6) {& $workdir\modules\essential\manualstuffs.ps1; UPV 7}

switch ($true) {
	
	default {exit}

	# Taskbar and desktop zone

	# A7
	{$hidetaskbaricons -and (SPV 7)} {
		& $workdir\modules\taskbar\hidetaskbaricons.ps1; UPV 8
	}

	# A8
	{$taskbarpins -and (SPV 8)} {
		& $workdir\modules\taskbar\removetaskbarpinneditems.ps1; UPV 9
	}

	# A9
	{$explorericon -and (SPV 9)} {
		& $workdir\modules\taskbar\explorericon.ps1; UPV 10
	}

	# A10
	{$oldbatteryflyout -and (SPV 10)} {
		& $workdir\modules\taskbar\oldbatteryflyout.ps1; UPV 11
	}

	# A11
	{$desktopshortcuts -and (SPV 11)} {
		& $workdir\modules\desktop\desktopshortcuts.ps1; UPV 12
	}

	# Installation zone

	# A12
	{$essentialapps -eq 1 -and (SPV 12)} {
		& $workdir\modules\apps\essentialapps.ps1; UPV 13
	}

	# Destruction zone

	# A13
	{$removeonedrive -and (SPV 13)} {
		& $workdir\modules\removal\removeonedrive.ps1; UPV 14
	}

	# A14
	{$removewaketimers -and (SPV 14)} {
		& $workdir\modules\removal\removewaketimers.ps1; UPV 15
	}

	# A15
	{$replaceemojifont -and (SPV 15)} {
		& $workdir\modules\removal\replaceemojifont.ps1; UPV 16
	}

	# A16
	{$removeedgeshortcut -and (SPV 16)} {
		& $workdir\modules\removal\removeedgeshortcut.ps1; UPV 17
	}

	# A17
	{$sltoshutdownwall -and (SPV 17)} {
		& $workdir\modules\desktop\slidetoshutdownwall.ps1; UPV 18
	}

	# A18
	{$registrytweaks -and (SPV 18)} {
		& $workdir\modules\essential\simpleregistry.ps1; UPV 19
	}

	# A19
	{$embeddedlogon -and $build -ge 14393 -and (SPV 19)} {
		& $workdir\modules\desktop\embeddedlogon.ps1; UPV 20
	}

	# A20
	{$removeUWPapps -and (SPV 20)} {
		# On certain builds, there is a freeze issue where the script will just hang here forever, we have to use another method...
		Start-Process $coredir\7z\7za.exe -Wait -NoNewWindow -ArgumentList "x $datadir\utils\SuwakoDebloaterLite-Bionic.7z -o$datadir\utils\SuwakoDebloaterLite-Bionic -aoa"
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing all UWP apps possible"
		Write-Host -ForegroundColor Cyan "This process will spit out of errors, and that is normal."
		Write-Host -ForegroundColor Cyan "In addition, it will also create a repeatedly flashing console HUD. If you are sensitive to flashes, please minimize or do not look at that window."
		if (-not $keepedgechromium) {$keepedgeparam = '$true $true'} else {$keepedgeparam = '$false $false'}
		$suwakoparam = "& $datadir\utils\SuwakoDebloaterLite-Bionic\Scripts\Remove-Runner.ps1" + ' $true $true $true $true ' + $keepedgeparam + '; Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name UWPAppsRemoved" -Value 1 -Type DWord -Force'
		Start-Process powershell -ArgumentList $suwakoparam
		while ($true) {
			$suwakodone = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").UWPAppsRemoved
			if ($suwakodone -eq 1) {break}
			Write-Host "." -n; Start-Sleep -Seconds 1
		}
		UPV 21
	}

	# A21
	{$customsounds -and (SPV 21)} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing custom system sounds" 
		Start-Process powershell -Wait -ArgumentList "$workdir\modules\desktop\customsounds.ps1"
		UPV 22
	}

	# A22
	{$removesystemapps -and (SPV 22)} {
		# Same as A20
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling system apps" 
		Start-Process powershell -ArgumentList "$workdir\modules\removal\removesystemapps.ps1"
		while ($true) {
			$sappdone = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SystemAppsRemoved
			if ($sappdone -eq 1) {break}
			Write-Host "." -n; Start-Sleep -Seconds 1
		}
		Write-Host " "; UPV 23
	}

	# A23
	{$disableaddressbar -and (SPV 23)} {
		& $workdir\modules\apps\addressbar.ps1; UPV 24
	}

}

# This the last action, and must not be interrupted.
Show-WindowTitle 3 99 noclose
& $coredir\servicing\hikarinstall.ps1 

# Finalize things, and the job ends!
if ($build -le 14393 -and $balloonnotifs -eq $false) {
	Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'EnableLegacyBalloonNotifications' -Value 0 -Type DWord -Force
}
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 0 -Type DWord -Force
Write-Host " "
Show-WindowTitle 3 100
Write-Host "This was the final step of the script. In order to complete the setup, please press Enter to restart" -ForegroundColor Black -BackgroundColor Green
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMusicStop" -Value 1 -Type DWord -Force
Start-Process "$datadir\ambient\FFPlay.exe" -Wait -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainCompletedAll.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
& $PSScriptRoot\notefinish.ps1
Write-Host " "; Show-Branding; Write-Host "Made by Bionic Butter with Love <3" -ForegroundColor Magenta
Read-Host
shutdown -r -t 6 -c " "
Stop-Script
