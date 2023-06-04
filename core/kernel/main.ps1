# BioniDKU main orchestrator file - (c) Bionic Butter

##############################################################
# Import basic functions and grab some neccessary variables
function Show-WindowTitle($s1) {
	if ($s1 -like "noclose") {
		$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter - DO NOT CLOSE THIS WINDOW"
	} else {
		$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter"
	}
}
Show-WindowTitle
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
	exit
}

# Set Working directory and Core folder's directory
$workdir = Split-Path(Split-Path "$PSScriptRoot")
$coredir = Split-Path "$PSScriptRoot"

# Load variables from the configuration file
. $coredir\kernel\config.ps1
. $workdir\modules\lib\getedition.ps1
$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR

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
Show-Branding clear
Show-WindowTitle noclose
Write-Host -ForegroundColor White "You're running Windows $editiontype $editiond, OS build"$build"."$ubr

# Get system variables
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Switching to normal mode"
$battery = (Get-CimInstance -ClassName Win32_Battery)

# Remove startup obstacles while in Hikaru mode 1, then switch back to mode 0
$hkm = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMode
if ($hkm -eq 1) {
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
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Starting Windows Explorer"
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 0 -Type DWord -Force
	& $coredir\kernel\hikaru.ps1
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ClearBootMessage" -Value 1 -Type DWord -Force
	& $workdir\modules\lib\interuptmessage.ps1
}

# Continue importing required components
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Initializing components"

$pendingreboot = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending')
$pendingrebootcount = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").PendingRebootCount
if ($pendingreboot -eq $true -and $build -ge 10240) {
	if ($pendingrebootcount -gt 3) {
		Show-WindowTitle
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
		& $coredir\kernel\hikaru.ps1
		Write-Host -ForegroundColor Black -BackgroundColor Yellow "Your PC have queued a restart more than 3 times!"
		Write-Host -ForegroundColor Yellow "This is likely due to Windows Update being busy at the moment. I suggest checking the page in Settings for any on-going updates, or check in Task Manager for any WU-related processes and wait for them to finish if possible."
		Write-Host -ForegroundColor White "If you wish to continue the script despite the pending restart, press Enter twice. Otherwise, please restart the system manually (the script will automatically resume when you do so)."
		Read-Host
		Read-Host
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value 'explorer.exe' -Type String
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 0 -Type DWord -Force
		Show-WindowTitle noclose
	} else {
		Show-WindowTitle
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Your PC has a pending restart, which has to be done before running this script. Automatically restarting in 5 seconds..."
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
		& $coredir\kernel\hikaru.ps1
		$pendingrebootcounting = $pendingrebootcount + 1
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "PendingRebootCount" -Value $pendingrebootcounting -Type DWord -Force
		Start-Sleep -Seconds 5
		shutdown -r -t 0
		Start-Sleep -Seconds 30
		exit
	}
}
Write-Host " "
$dotnet35done = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").dotnet35
$dotnet462done = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").dotnetrebooted
$setupmusic = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic
$essentialapps = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).EssentialApps



# Now into the business

if ($setupmusic -eq 1) {
	Write-Host "Starting Music player in the background" -BackgroundColor DarkGray -ForegroundColor Cyan
	Start-Process powershell -WindowStyle Hidden -ArgumentList "-Command $workdir\music\musicplayer.ps1"
}

& $workdir\modules\removal\unsealtheclasses.ps1

switch ($true) {
	
	{$dotnet35 -and $dotnet35done -ne 1} {
		Write-Host "Enabling .NET 3.5" -ForegroundColor Cyan -BackgroundColor DarkGray
		Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3"
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "dotnet35" -Value 1 -Type DWord -Force
	}
	
	{$dotnet462 -and $dotnet462done -ne 1} {
		& $workdir\modules\apps\dotnet462install.ps1
	}
	
	{$removehomegroup -eq $true -and $build -lt 17134} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Partially removing HomeGroup"
		# First, with the permission seal removed earlier, DESTROY the key
		Remove-Item "HKLM:\SOFTWARE\Classes\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}" -Recurse
		# Then, we need to disable the service.
		Stop-Service -Name HomeGroupProvider
		Stop-Service -Name HomeGroupListener
		Start-Process sc.exe -Wait -NoNewWindow -ArgumentList "config HomeGroupProvider start= DISABLED"
		Start-Process sc.exe -Wait -NoNewWindow -ArgumentList "config HomeGroupListener start= DISABLED"
		# And all it's left is to tell the user to right click and delete the key in Explorer, done!
	}
	
}

& $workdir\modules\essential\manualstuffs.ps1

switch ($true) {
	
	default {
		exit
	}

	# Taskbar and desktop zone

	$hidetaskbaricons {
		& $workdir\modules\taskbar\hidetaskbaricons.ps1
	}

	$taskbarpins {
		& $workdir\modules\taskbar\removetaskbarpinneditems.ps1
	}

	$explorericon {
		& $workdir\modules\taskbar\explorericon.ps1
	}

	$oldbatteryflyout {
		& $workdir\modules\taskbar\oldbatteryflyout.ps1
	}

	$desktopshortcuts {
		& $workdir\modules\desktop\desktopshortcuts.ps1
	}

	# Installation zone

	{$essentialapps -eq 1} {
		& $workdir\modules\apps\essentialapps.ps1
	}

	# Destruction zone

	$removeonedrive {
		& $workdir\modules\removal\removeonedrive.ps1
	}

	$removewaketimers {
		& $workdir\modules\removal\removewaketimers.ps1
	}

	$replaceemojifont {
		& $workdir\modules\removal\replaceemojifont.ps1
	}

	$removeedgeshortcut {
		& $workdir\modules\removal\removeedgeshortcut.ps1
	}

	$sltoshutdownwall {
		& $workdir\modules\desktop\slidetoshutdownwall.ps1
	}

	$registrytweaks {
		& $workdir\modules\essential\simpleregistry.ps1
	}

	$removeUWPapps {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing all UWP apps possible" 
		Start-Process powershell -Wait -ArgumentList "$workdir\modules\removal\removeuwpapps.ps1"
	}

	$customsounds {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing custom system sounds" 
		Start-Process powershell -Wait -ArgumentList "$workdir\modules\desktop\customsounds.ps1"
	}

	$removesystemapps {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling system apps" 
		Start-Process powershell -Wait -ArgumentList "$workdir\modules\removal\removesystemapps.ps1"
	}

	$disableaddressbar {
		& $workdir\modules\apps\addressbar.ps1
	}

}

if ($build -le 14393 -and $balloonnotifs -eq $false) {
	Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'EnableLegacyBalloonNotifications' -Value 0 -Type DWord -Force
}
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 0 -Type DWord -Force
& $coredir\servicing\hikarinstall.ps1
Write-Host " "
Show-WindowTitle
Write-Host "This was the final step of the script. In order to complete the setup, please press Enter to restart" -ForegroundColor Black -BackgroundColor Green
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMusicStop" -Value 1 -Type DWord -Force
Start-Process "$coredir\ambient\FFPlay.exe" -Wait -WindowStyle Hidden -ArgumentList "-i $coredir\ambient\DomainCompletedAll.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
& $PSScriptRoot\notefinish.ps1
Write-Host " "; Show-Branding; Write-Host "Made by Bionic Butter with Love <3" -ForegroundColor Magenta
Read-Host
shutdown -r -t 5 -c "BioniDKU needs to restart your PC to complete the setup"
Stop-Script
