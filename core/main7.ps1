$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter and Sunryze"
$butter = "Build 22107.200_pwsh7.uec_release.04122022-1647"
function Show-Branding($s1,$s2) {
	if ($s1 -like "clear") {Clear-Host}
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "Stable Release - $butter" -ForegroundColor Magenta -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
	if ($s2 -like "creds") {
		Write-Host " "; Write-Host "--------------------------------------------------------------"; Write-Host " "
		Write-Host "     Original author : @sunryze#5817"
		Write-Host "     Testers         : @Julia#6033, @Zippykool#3826"
		Write-Host "     And special thanks to everyone else's contributions"
		Write-Host " "; Write-Host "--------------------------------------------------------------"; Write-Host " "
	}
}

##############################################################
### Everything inside these two lines of 63 hashes are the 
### only thing you should modify. PLEASE DO NOT MOFIDY 
### ANYTHING ELSE IN THIS FILE!

### ------ REQUIRED MODULES, PLEASE DO NOT DISABLE ------
$manualstuffs =	        $true
$disableuac =           $true

### ------ SCRIPT CONFIGURATION: Module Switches ------

$setupmusic =           $true

$requiredprograms =     $true
$hidetaskbaricons =     $true
$replaceneticon =       $true
$removeedge =           $true
$windowsupdate =        $true
$setwallpaper =         $true
$dotnet35 =             $true 
$dotnet462 =            $true
$sharex462 =            $true
$paintdotnet462 =       $true 
$desktopshortcuts =     $true 
$removeudpassistant =   $true 
$removewaketimers =     $true 
$removeUWPapps =        $true 
$openshellconfig =      $true 
$explorericon =         $true
$classicapps =          $true 
$taskbarpins =          $true
$replaceemojifont =     $true 
$defaultapps =          $true 
$disablesettings =      $true 
$blockapps =            $true 
$gpomodifs =            $true 
$disableaddressbar =    $true
$removeonedrive =       $true
$removehomegroup =      $true
$explorerstartfldr =    $true 
$oldbatteryflyout =     $true 
$customsounds =         $true

### ------ SCRIPT CONFIGURATION: Registry Switches ------
# Below are registry-applied tweaks. You can disable all of them,
# or you can disable a specific one.

$registrytweaks =       $true # Master switch for all option below

$disablestartupitems =  $true
$disablenotifs =        $true 
$disablegamebar =       $true 
$disableautoplay =      $true 
$disablemultitaskbar =  $true
$transparencydisable =  $true 
$disableanimations =    $true 
$disablewinink =        $true 
$removedownloads =      $true
$applookupinstore =     $true
$contextmenuentries =   $true
$1709peoplebar =        $true
$1511locationicon =     $true
$removequickaccess =    $true
$disablelocationicon =  $true 
$activatephotoviewer =  $true 
$registeredowner =      $true 
$classicpaint =         $true 
$disableedgeprelaunch = $true
$disablecortana =       $true 
$disablestoreautoupd =  $true
$balloonnotifs =        $true 
$showalltrayicons =     $false # Recommended TRUE only if 1511+
$disablelockscrn =      $true
$darkmodeoff =          $true 
$classicalttab =        $true
$oldvolcontrol =        $true
$defaultcolor =         $true
$remove3Dobjects =      $true
$hidebluetoothicon =    $true
$disablelogonbg =       $true
$svchostslimming =      $true
$letsNOTfinish =        $true

& $PSScriptRoot\modules.ps1
function Get-ConfigStat {
	$confuled = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ConfigSet
	if ($confuled -eq 2) {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 1 -Type DWord -Force
		exit
	}
	if ($confuled -eq 0) {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 0 -Type DWord -Force
		exit
	}
}
Get-ConfigStat
##############################################################

Show-Branding clear
# PowerShell 7 compatibility layer loader
Import-Module Microsoft.PowerShell.Management
Import-Module ScheduledTasks -SkipEditionCheck

# Remove the other PowerShell counterpart
$pwsh = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Pwsh
$psop = Test-Path -Path "$PSScriptRoot\main5.ps1" -PathType Leaf
if ($psop -eq $true) {Remove-Item "$PSScriptRoot\main5.ps1"}

# Set Working Directory
$workdir = "$PSScriptRoot\.."

# Clear out any pending script resume orders
& $PSScriptRoot\unsume.ps1

### ------ System Variables ------
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Finding your Windows 10 build number" -n; Write-Host ([char]0xA0)

$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
$battery = (Get-CimInstance -ClassName Win32_Battery)

if ($build -le 17134 -and $build -ge 10240) {
    $tls1 = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319').SchUseStrongCrypto
    $tls2 = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319').SchUseStrongCrypto
    if ($tls1 -eq 0 -or $tls2 -eq 0 -or $null -eq $tls1 -or $null -eq $tls2) {
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
        Write-Host -ForegroundColor Yellow -BackgroundColor DarkGray "This version of Windows requires certain TLS settings. Restarting the script for them to take effect..."
        Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 1 -Type DWord -Force
        exit
    }
}

### ------ Continue importing required dependencies ------
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Continuing to import required dependencies" -n; Write-Host ([char]0xA0)

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Add-Type -AssemblyName presentationCore
switch ($build) {
	{$_ -ge 17763} {
		# I'm not sure if this will happen on older, but that's the oldest build I know to have Edge after updating
		$chedgeck = Get-Process msedge -ErrorAction SilentlyContinue
		if ($chedgeck) {
			Write-Host "Getting Microsoft Edge out of the way" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
			Stop-Process -Name msedge -Force
		}
	}
    {$_ -ge 10240} {
        $pendingreboot = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending')
        if ($pendingreboot -eq $true -and $build -ge 10240) {
            Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Your PC has a pending restart, which has to be done before running this script. Automatically restarting in 5 seconds..." -n; Write-Host ([char]0xA0)
			& $PSScriptRoot\resume.ps1
			Start-Sleep -Seconds 5
			shutdown -r -t 0
			Start-Sleep -Seconds 30
			exit
        }
    Install-Module MusicPlayer -scope CurrentUser -Verbose -Repository 'PSGallery'
    Import-Module MusicPlayer -Verbose
    }
    {$_ -ge 14393} {
        Install-Module PSWindowsUpdate
        Import-Module PSWindowsUpdate -Verbose
    }
}
Import-Module BitsTransfer -Verbose

##### ------ Functions ------
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Importing Functions" -n; Write-Host ([char]0xA0)
Function Set-WallPaper($Image) {
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

switch ($true) {
    default {
        Write-Host "You did not select anything to do and will be taken back to the configuration screen next time you start the script. Press Enter to exit." -ForegroundColor Red -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 0 -Type DWord -Force
        Read-Host
		exit
    }

    $setupmusic {
		Write-Host "Setting up Music" -BackgroundColor DarkGray -ForegroundColor Cyan -n; Write-Host ([char]0xA0)
		Start-Process pwsh -Wait -ArgumentList "-Command $workdir\music\musicn.ps1" -WorkingDirectory $workdir\music
        & $PSScriptRoot\..\modules\essential\setupmusic7.ps1
    }

    $setwallpaper {
        & $PSScriptRoot\..\modules\desktop\wallpaper.ps1
    }
    
	$disableuac {
		# This has to be done first, otherwise you'll get UAC prompting on script resume-on-reboot
		# which is not ideal when the goal is to get fully automated
        Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling UAC" -n; Write-Host ([char]0xA0)
        Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name ConsentPromptBehaviorAdmin -Value 0
    }
	
    $letsNOTfinish {
		& $PSScriptRoot\..\modules\removal\letsNOTfinish.ps1
	}
	
	{$windowsupdate -eq $true -and $build -ge 14393} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Doing Windows Updates before running the script" -n; Write-Host ([char]0xA0)
		& $PSScriptRoot\..\modules\essential\cWUngus.ps1
		Get-ConfigStat
        & $PSScriptRoot\..\modules\essential\windowsupdate.ps1
    }
	
	{$dotnet35 -eq $true -and $dotnet35done -ne 1} {
        Write-Host "Enabling .NET 3.5" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
        Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3"
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "dotnet35" -Value 1 -Type DWord -Force
    }
	
	$manualstuffs {
		& $PSScriptRoot\..\modules\essential\manualstuffs.ps1
	}
	
    $hidetaskbaricons {
        & $PSScriptRoot\..\modules\taskbar\hidetaskbaricons.ps1
    }

    {$replaceneticon -eq $true -and $build -ge 18362} {
        & $PSScriptRoot\..\modules\taskbar\1903neticon.ps1
    }

    $removeonedrive {
        & $PSScriptRoot\..\modules\removal\removeonedrive.ps1
    }  

    {$removehomegroup -eq $true -and $build -lt 17134} {
        & $PSScriptRoot\..\modules\removal\removehomegroup.ps1
    }

    $desktopshortcuts {
        & $PSScriptRoot\..\modules\desktop\desktopshortcuts.ps1
    }

    $requiredprograms {
        & $PSScriptRoot\..\modules\apps\requiredprograms.ps1
    }

    $sharex462 {
        & $PSScriptRoot\..\modules\apps\sharex462.ps1
    }

    $paintdotnet462 {
        & $PSScriptRoot\..\modules\apps\paintdotnet.ps1
    }

    $removeedge {
        & $PSScriptRoot\..\modules\removal\removeedge.ps1
    }

    $removewaketimers {
        & $PSScriptRoot\..\modules\removal\removewaketimers.ps1
    }
    
    $removeUWPapps {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing all UWP apps possible" -n; Write-Host ([char]0xA0) 
        Start-Process pwsh -Wait -ArgumentList "$PSScriptRoot\..\modules\removal\removeuwpapps.ps1"
    }

    $taskbarpins {
        & $PSScriptRoot\..\modules\taskbar\removetaskbarpinneditems.ps1
    }

    $explorerstartfldr {
        & $PSScriptRoot\..\modules\desktop\explorerstartfldr.ps1
    }

    {$explorericon -eq $true} {
        & $PSScriptRoot\..\modules\taskbar\explorericon.ps1
    }
	
    $disableaddressbar {
        & $PSScriptRoot\..\modules\apps\addressbar.ps1
    }

    $oldbatteryflyout {
        & $PSScriptRoot\..\modules\taskbar\oldbatteryflyout.ps1
    }

    $classicapps {
        & $PSScriptRoot\..\modules\apps\classicapps.ps1
    }

    $openshellconfig {
        & $PSScriptRoot\..\modules\apps\openshellconfig.ps1
    }

    $registrytweaks {
        & $PSScriptRoot\..\modules\essential\simpleregistry.ps1
    }

    $customsounds {
        & $PSScriptRoot\..\modules\desktop\customsounds.ps1
    }

    $replaceemojifont {
        & $PSScriptRoot\..\modules\removal\replaceemojifont.ps1
    }
}

# One again clear out any pending script resume orders
& $PSScriptRoot\unsume.ps1

Write-Host " " -n; Write-Host ([char]0xA0)
Write-Host "This was the final step of the script. Press Enter to reboot, and then the IDKU will be fully setup!" -ForegroundColor Black -BackgroundColor Green -n; Write-Host ([char]0xA0)
& $PSScriptRoot\notefinish.ps1
Write-Host " "; Show-Branding; Write-Host "Made by Bionic Butter, with Love from Vietnam <3" -ForegroundColor Magenta -n; Write-Host ([char]0xA0)
Read-Host
shutdown -r -t 5 -c "BioniDKU needs to restart your PC to complete the process"
exit