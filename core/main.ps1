$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter"
$releasetype = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ReleaseType
$butter = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ReleaseID
$pwsh = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Pwsh
function Show-Branding($s1) {
	if ($s1 -like "clear") {Clear-Host}
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "$releasetype - $butter" -ForegroundColor Magenta -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
# Set Working Directory first before anything else
$workdir = "$PSScriptRoot\.."

##############################################################
# Load variables from the configuration file
. $PSScriptRoot\config.ps1

# Importing some basic functions required for the modules menu
function Set-WallPaper($Image) {
Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}

& $PSScriptRoot\modules.ps1
function Get-ConfigStat {
	$confuled = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ConfigSet
	if ($confuled -eq 2) {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 3 -Type DWord -Force
		exit
	}
	elseif ($confuled -eq 0) {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 0 -Type DWord -Force
		exit
	}
}
Get-ConfigStat
##############################################################


######################## BEGIN SCRIPT ########################

# Show branding
Show-Branding clear

# System Variables
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Initializing environment" -n; Write-Host ([char]0xA0)

$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
$battery = (Get-CimInstance -ClassName Win32_Battery)
Write-Host "You're running Windows 10 build"$build"."$ubr

# Remove startup obstacles while in Hikaru mode 1, then switch back to mode 0
$hkm = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMode
if ($hkm -eq 1) {
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing startup obstacles" -n; Write-Host ([char]0xA0)
	& $workdir\modules\removal\letsNOTfinish.ps1
	if ($build -ge 17763) {
		Start-Process powershell -ArgumentList "-Command $workdir\modules\removal\edgekiller.ps1"
		Start-Sleep -Seconds 3
	}
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Starting Windows Explorer" -n; Write-Host ([char]0xA0)
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 0 -Type DWord -Force
	& $PSScriptRoot\hikaru.ps1
}

# Continue importing required dependencies
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Initializing components" -n; Write-Host ([char]0xA0)

$pendingreboot = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending')
$pendingrebootcount = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").PendingRebootCount
if ($pendingreboot -eq $true -and $build -ge 10240) {
	if ($pendingrebootcount -gt 3) {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
		& $PSScriptRoot\hikaru.ps1
		Write-Host -ForegroundColor Black -BackgroundColor Yellow "Your PC have queued a restart more than 3 times!" -n; Write-Host ([char]0xA0)
		Write-Host -ForegroundColor Yellow "This is likely due to Windows Update being busy at the moment. I suggest checking the page in Settings for any on-going updates, or check in Task Manager for any WU-related processes and wait for them to finish if possible."
		Write-Host -ForegroundColor White "If you wish to continue the script despite the pending restart, press Enter twice. Otherwise, please restart the system manually (the script will automatically resume when you do so)."
		Read-Host
		Read-Host
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value 'explorer.exe' -Type String
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 0 -Type DWord -Force
	} else {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Your PC has a pending restart, which has to be done before running this script. Automatically restarting in 5 seconds..." -n; Write-Host ([char]0xA0)
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
		& $PSScriptRoot\hikaru.ps1
		$pendingrebootcounting = $pendingrebootcount + 1
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "PendingRebootCount" -Value $pendingrebootcounting -Type DWord -Force
		Start-Sleep -Seconds 5
		shutdown -r -t 0
		Start-Sleep -Seconds 30
		exit
	}
}

Import-Module BitsTransfer -Verbose


##### ------ Functions ------
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Importing Functions" -n; Write-Host ([char]0xA0)
$global:musicplayer = ""
function Stop-Script {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMusicStop" -Value 1 -Type DWord -Force
	Stop-Process -Name "FFPlay" -Force -ErrorAction SilentlyContinue
	exit
}

function Take-Permissions {
    # Developed for PowerShell v4.0
    # Required Admin privileges
    # Links:
    #   http://shrekpoint.blogspot.ru/2012/08/taking-ownership-of-dcom-registry.html
    #   http://www.remkoweijnen.nl/blog/2012/01/16/take-ownership-of-a-registry-key-in-powershell/
    #   https://powertoe.wordpress.com/2010/08/28/controlling-registry-acl-permissions-with-powershell/

    param($rootKey, $key, [System.Security.Principal.SecurityIdentifier]$sid = 'S-1-5-32-545', $recurse = $true)

    switch -regex ($rootKey) {
        'HKCU|HKEY_CURRENT_USER'    { $rootKey = 'CurrentUser' }
        'HKLM|HKEY_LOCAL_MACHINE'   { $rootKey = 'LocalMachine' }
        'HKCR|HKEY_CLASSES_ROOT'    { $rootKey = 'ClassesRoot' }
        'HKCC|HKEY_CURRENT_CONFIG'  { $rootKey = 'CurrentConfig' }
        'HKU|HKEY_USERS'            { $rootKey = 'Users' }
    }

    ### Step 1 - escalate current process's privilege
    # get SeTakeOwnership, SeBackup and SeRestore privileges before executes next lines, script needs Admin privilege
    $import = '[DllImport("ntdll.dll")] public static extern int RtlAdjustPrivilege(ulong a, bool b, bool c, ref bool d);'
    $ntdll = Add-Type -Member $import -Name NtDll -PassThru
    $privileges = @{ SeTakeOwnership = 9; SeBackup =  17; SeRestore = 18 }
    foreach ($i in $privileges.Values) {
        $null = $ntdll::RtlAdjustPrivilege($i, 1, 0, [ref]0)
    }

    function Take-KeyPermissions {
        param($rootKey, $key, $sid, $recurse, $recurseLevel = 0)

        ### Step 2 - get ownerships of key - it works only for current key
        $regKey = [Microsoft.Win32.Registry]::$rootKey.OpenSubKey($key, 'ReadWriteSubTree', 'TakeOwnership')
        $acl = New-Object System.Security.AccessControl.RegistrySecurity
        $acl.SetOwner($sid)
        $regKey.SetAccessControl($acl)

        ### Step 3 - enable inheritance of permissions (not ownership) for current key from parent
        $acl.SetAccessRuleProtection($false, $false)
        $regKey.SetAccessControl($acl)

        ### Step 4 - only for top-level key, change permissions for current key and propagate it for subkeys
        # to enable propagations for subkeys, it needs to execute Steps 2-3 for each subkey (Step 5)
        if ($recurseLevel -eq 0) {
            $regKey = $regKey.OpenSubKey('', 'ReadWriteSubTree', 'ChangePermissions')
            $rule = New-Object System.Security.AccessControl.RegistryAccessRule($sid, 'FullControl', 'ContainerInherit', 'None', 'Allow')
            $acl.ResetAccessRule($rule)
            $regKey.SetAccessControl($acl)
        }

        ### Step 5 - recursively repeat steps 2-5 for subkeys
        if ($recurse) {
            foreach($subKey in $regKey.OpenSubKey('').GetSubKeyNames()) {
                Take-KeyPermissions $rootKey ($key+'\'+$subKey) $sid $recurse ($recurseLevel+1)
            }
        }
    }
Take-KeyPermissions $rootKey $key $sid $recurse
}

##################### Begin Script #####################
Write-Host " "
$dotnet35done = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").dotnet35
$dotnet462done = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").dotnetrebooted
$setupmusic = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic
$manualstuffs = $true # Please DO NOT set to false
if ($setupmusic -eq 1) {
	Write-Host "Setting up Music" -BackgroundColor DarkGray -ForegroundColor Cyan -n; Write-Host ([char]0xA0)
	Start-Process powershell -Wait -ArgumentList "-Command $workdir\music\musicn.ps1" -WorkingDirectory $workdir\music
	Start-Process powershell -WindowStyle Hidden -ArgumentList "-Command $workdir\music\musics.ps1"
}


switch ($true) {
	
	default {
		Write-Host "You did not select anything to do and will be taken back to the configuration screen next time you start the script. Press Enter to exit." -ForegroundColor Red -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 0 -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 0 -Type DWord -Force
		Read-Host
		exit
	}
	
	{$dotnet35 -eq $true -and $dotnet35done -ne 1} {
		Write-Host "Enabling .NET 3.5" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
		Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3"
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "dotnet35" -Value 1 -Type DWord -Force
	}
	
	{$dotnet462 -eq $true -and $dotnet462done -ne 1} {
		& $workdir\modules\apps\dotnet462install.ps1
	}
	
	$manualstuffs {
		& $workdir\modules\essential\manualstuffs.ps1
	}
	
	$hidetaskbaricons {
		& $workdir\modules\taskbar\hidetaskbaricons.ps1
	}

	$removeonedrive {
		& $workdir\modules\removal\removeonedrive.ps1
	}  

	{$removehomegroup -eq $true -and $build -lt 17134} {
		& $workdir\modules\removal\removehomegroup.ps1
	}

	$desktopshortcuts {
		& $workdir\modules\desktop\desktopshortcuts.ps1
	}

	$essentialapps {
		& $workdir\modules\apps\essentialapps.ps1
	}

	$openshellconfig {
		& $workdir\modules\apps\openshellconfig.ps1
	}

	$removewaketimers {
		& $workdir\modules\removal\removewaketimers.ps1
	}

	$removeUWPapps {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing all UWP apps possible" -n; Write-Host ([char]0xA0) 
		Start-Process powershell -Wait -ArgumentList "$workdir\modules\removal\removeuwpapps.ps1"
	}

	$taskbarpins {
		& $workdir\modules\taskbar\removetaskbarpinneditems.ps1
	}

	$explorericon {
		& $workdir\modules\taskbar\explorericon.ps1
	}

	$disableaddressbar {
		& $workdir\modules\apps\addressbar.ps1
	}

	$oldbatteryflyout {
		& $workdir\modules\taskbar\oldbatteryflyout.ps1
	}

	$registrytweaks {
		& $workdir\modules\essential\simpleregistry.ps1
	}

	$customsounds {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing custom system sounds" -n; Write-Host ([char]0xA0) 
		Start-Process powershell -Wait -ArgumentList "$workdir\modules\desktop\customsounds.ps1"
	}

	$replaceemojifont {
		& $workdir\modules\removal\replaceemojifont.ps1
	}

	$removeedgeshortcut {
		& $workdir\modules\removal\removeedgeshortcut.ps1
	}

	$removesystemapps {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling system apps" -n; Write-Host ([char]0xA0) 
		Start-Process powershell -Wait -ArgumentList "$workdir\modules\removal\removesystemapps.ps1"
	}

	$sltoshutdownwall {
		& $workdir\modules\desktop\slidetoshutdownwall.ps1
	}

}

Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 0 -Type DWord -Force
& $PSScriptRoot\hikarinstall.ps1
Write-Host " " -n; Write-Host ([char]0xA0)
Write-Host "This was the final step of the script. Press Enter to restart and complete the setup" -ForegroundColor Black -BackgroundColor Green -n; Write-Host ([char]0xA0)
Start-Process "$PSScriptRoot\ambient\FFPlay.exe" -Wait -WindowStyle Hidden -ArgumentList "-i $PSScriptRoot\ambient\DomainCompletedAll.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
& $PSScriptRoot\notefinish.ps1
Write-Host " "; Show-Branding; Write-Host "Made by Bionic Butter with Love <3" -ForegroundColor Magenta -n; Write-Host ([char]0xA0)
Read-Host
shutdown -r -t 5 -c "BioniDKU needs to restart your PC to complete the setup"
Stop-Script
