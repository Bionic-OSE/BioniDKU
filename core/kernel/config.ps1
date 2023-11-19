## Project BioniDKU - Next Generation AutoIDKU
## Advanced configuration file & menu

#! The only things you should modify in this file are values under the 'Switch' column, with '$true' meaning 
#! True/ON and '$false' meaning False/OFF. I've made this layout in the most user-friendly way possible, so
#! you should have no problem understanding what does which, given that you ignore the "weird" stuffs you see
#! and only focus on changing the lines to True or False.
#! These options have already been optimized for most use cases, so it's recommended that you should leave it
#! the way it is.

## -------------------- Friendly name --------------------- | ------ Variable name ------- | ------ Switch ------ |

## ================================================ MODULE SWITCHES ===============================================
## These are most of the things the script will do during its execution.

<# Install .NET 4.6.2 (10586-)**** #> if ($pwsh -eq 5) {      $dotnet462 =                   $true }
<# Enable .NET 3.5 #>                                         $dotnet35 =                    $true
<# Hide system icons from the taskbar #>                      $hidetaskbaricons =            $true
<# Remove Microsoft Edge Shortcuts** #>                       $removeedgeshortcut =          $true
<# Create desktop shortcuts #>                                $desktopshortcuts =            $true
<# Disable Wake timers #>                                     $removewaketimers =            $true
<# Remove all UWP apps possible #>                            $removeUWPapps =               $true
<# Use script's Open-Shell config* #>                         $openshellconfig =             $true
<# Replace Explorer taskbar icon (17763-) #>                  $explorericon =                $true
<# Remove taskbar pins #>                                     $taskbarpins =                 $true
<# Replace seguiemj.ttf with Windows 11's #>                  $replaceemojifont =            $true 
<# Set default apps #>                                        $defaultapps =                 $true 
<# Remove Explorer address bar #>                             $disableaddressbar =           $false
<# Shrink Explorer address bar (18363 & 1904x only) #>        $thinneraddressbar =           $true
<# Remove Microsoft OneDrive #>                               $removeonedrive =              $true
<# Remove HomeGroup (16299-) #>                               $removehomegroup =             $true
<# Default Explorer to This PC***** #>                        $explorerstartfldr =           $true
<# Use classic battery flyout #>                              $oldbatteryflyout =            $true
<# Install custom system sound #>                             $customsounds =                $true
<# Disable some system apps*** #>                             $removesystemapps =            $true
<# Replace SlideToShutDown.exe background #>                  $sltoshutdownwall =            $true
<# Don't touch Edge Chromium** #>                             $keepedgechromium =            $false
<# Keep Windows Search*** #>                                  $keepsearch =                  $true
<# Keep UAC (Stable only) #>                                  $keepuac =                     $true
<# Hide LogonUI spin screens (non-Home/Servers, 14393+) #>    $embeddedlogon =               $true

#i     *  You MUST enable the Essential Apps option and include Open-Shell in the apps selection.
#i    **  If you choose to $keepedgechromium, $removeedgeshortcut be skipped if it's installed.
#i        (MEANING on certain builds if you have Chromium alongside Legacy shortcuts for both will NOT be removed!)
#i   ***  $keepsearch is an option of $removesystemapps, and will have no effect if the latter is disabled.
#i  ****  If you choose not to install .NET 4.6.2 on 10240, the classic WU disabling method will be used.
#i *****  If you disable this option, Quick Access will not be removed.

## ================================================ REGISTRY SWICHES ===============================================
## Below are registry-applied tweaks. You can enable/disable all of them, or toggle individual options.

<# Enable registry tweaks #>                                  $registrytweaks =              $true # Master switch for the rest below

<# Disable Defender startup entry #>                          $disabledefenderstart =        $true
<# Disable Toast notifications #>                             $disablenotifs =               $true 
<# Disale Game Bar #>                                         $disablegamebar =              $true 
<# Disale AutoPlay #>                                         $disableautoplay =             $true 
<# Disale multi-monitor taskbar #>                            $disablemultitaskbar =         $true
<# Disale Transparency #>                                     $disabletransparency =         $true 
<# Disale window animations #>                                $disableanimations =           $true 
<# Disale Windows Ink Workspace (15063+) #>                   $disablewinink =               $true 
<# Remove Downloads folder #>                                 $removedownloads =             $true
<# Disable "Look for this app in Store" #>                    $applookupinstore =            $true
<# Tune the Context menu #>                                   $contextmenuentries =          $true
<# Remove Quick Access #>                                     $removequickaccess =           $true
<# Disable Location icon*** #>                                $disablelocationicon =         $true 
<# Activate Windows Photos viewer #>                          $activatephotoviewer =         $true 
<# Set Registered owner #>                                    $registeredowner =             $true 
<# Enable Classic paint #>                                    $classicpaint =                $true 
<# Disable Edge prelaunch on startup #>                       $disableedgeprelaunch =        $true
<# Disable Cortana #>                                         $disablecortana =              $true 
<# Disable automatic update of UWPs #>                        $disablestoreautoupd =         $true
<# Enable classic ballon notifications #>                     $balloonnotifs =               $true 
<# Show all icons in taskbar tray #>                          $showalltrayicons =            $false 
<# Show hidden system files and folders #>                    $showsuperhidden =             $false 
<# Disable Lock screen #>                                     $disablelockscrn =             $true
<# Use classic Alt+Tab #>                                     $classicalttab =               $true
<# Use classic volume control #>                              $oldvolcontrol =               $true
<# Set accent color to Default Blue #>                        $defaultcolor =                $true
<# Remove 3D objects (16299+) #>                              $remove3Dobjects =             $true
<# Hide Bluetooth icon #>                                     $hidebluetoothicon =           $true
<# Disable Login screen background #>                         $disablelogonbg =              $true
<# Remove Network icon from login screen #>                   $removelckscrneticon =         $true
<# Disable Power Throttling #>                                $nopowerthrottling =           $false
<# Reduce the amount of svchost.exes #>                       $svchostslimming =             $true

## ^.^

## ================================================================================================================

#! This section below is for the main menu to display the options. Do NOT modify this!

function Show-ModulesConfig {
	Show-Branding clear
	Write-Host "------ ADVANCED SCRIPT CONFIGURATION: Module Switches ------" -ForegroundColor Black -BackgroundColor Green
	Write-Host 'BioniDKU is a script bundle consisting multiple script files, called "(BioniDKU) Modules".' -ForegroundColor Green
	Write-Host 'Below are most of the function modules you can adjust, each should be self-explainatory:' -ForegroundColor Green
	Write-Host " "; if ($pwsh -eq 5) {
	Write-Host "Install .NET 4.6.2 (10586-)****                      " -n; Write-Host -ForegroundColor White "$dotnet462           "}
	Write-Host "Enable .NET 3.5                                      " -n; Write-Host -ForegroundColor White "$dotnet35            "
	Write-Host "Hide system icons from the taskbar                   " -n; Write-Host -ForegroundColor White "$hidetaskbaricons    "
	Write-Host "Remove Microsoft Edge Shortcuts**                    " -n; Write-Host -ForegroundColor White "$removeedgeshortcut  "
	Write-Host "Create desktop shortcuts                             " -n; Write-Host -ForegroundColor White "$desktopshortcuts    "
	Write-Host "Disable Wake timers                                  " -n; Write-Host -ForegroundColor White "$removewaketimers    "
	Write-Host "Remove all UWP apps possible                         " -n; Write-Host -ForegroundColor White "$removeUWPapps       "
	Write-Host "Use script's Open-Shell config*                      " -n; Write-Host -ForegroundColor White "$openshellconfig     "
	Write-Host "Replace Explorer taskbar icon (17763-)               " -n; Write-Host -ForegroundColor White "$explorericon        "
	Write-Host "Remove taskbar pins                                  " -n; Write-Host -ForegroundColor White "$taskbarpins         "
	Write-Host "Replace seguiemj.ttf with Windows 11's               " -n; Write-Host -ForegroundColor White "$replaceemojifont    "
	Write-Host "Set default apps                                     " -n; Write-Host -ForegroundColor White "$defaultapps         "
	Write-Host "Remove Explorer address bar                          " -n; Write-Host -ForegroundColor White "$disableaddressbar   "
	Write-Host "Shrink Explorer address bar (18363 & 1904x only)     " -n; Write-Host -ForegroundColor White "$thinneraddressbar   "
	Write-Host "Remove Microsoft OneDrive                            " -n; Write-Host -ForegroundColor White "$removeonedrive      "
	Write-Host "Remove HomeGroup (16299-)                            " -n; Write-Host -ForegroundColor White "$removehomegroup     "
	Write-Host "Default Explorer to This PC*****                     " -n; Write-Host -ForegroundColor White "$explorerstartfldr   "
	Write-Host "Use classic battery flyout                           " -n; Write-Host -ForegroundColor White "$oldbatteryflyout    "
	Write-Host "Install custom system sound                          " -n; Write-Host -ForegroundColor White "$customsounds        "
	Write-Host "Disable some system apps***                          " -n; Write-Host -ForegroundColor White "$removesystemapps    "
	Write-Host "Replace SlideToShutDown.exe background               " -n; Write-Host -ForegroundColor White "$sltoshutdownwall    "
	Write-Host "Don't touch Edge Chromium**                          " -n; Write-Host -ForegroundColor White "$keepedgechromium    "
	Write-Host "Keep Windows Search***                               " -n; Write-Host -ForegroundColor White "$keepsearch          "
	Write-Host "Keep UAC (Stable only)                               " -n; Write-Host -ForegroundColor White "$keepuac             "
	Write-Host "Hide LogonUI spin screens (non-Home/Servers, 14393+) " -n; Write-Host -ForegroundColor White "$embeddedlogon       "
	Write-Host " "
	Write-Host "    * You MUST enable the Essential Apps option and include Open-Shell or this will have no effect." -ForegroundColor Cyan
	Write-Host "   ** If you keep Edge Chromium, the Edge Shortcut removal will be skipped if it's installed." -ForegroundColor Cyan
	Write-Host "    (MEANING on certain builds if you have Chromium alongside Legacy shortcuts for both will NOT be removed!)" -ForegroundColor Cyan
	Write-Host "  *** Keep Windows Search is an option of Disable system apps, and will have no effect if disabling the latter." -ForegroundColor Cyan
	if ($pwsh -eq 5) {Write-Host " **** If you choose not to install .NET 4.6.2 on 10240, the classic WU disabling method will be used." -ForegroundColor Cyan}
	if ($registrytweaks) {Write-Host "***** If you disable this option, Quick Access will not be removed." -ForegroundColor Cyan}
	Write-Host " "
	Write-Host "------ ADVANCED SCRIPT CONFIGURATION: Registry Switches ------" -ForegroundColor Black -BackgroundColor Green
	Write-Host " "
	Write-Host "Enable registry tweaks                               " -n; Write-Host -ForegroundColor White "$registrytweaks      "
	Write-Host " "; if ($registrytweaks) { 
	Write-Host "Disable Defender startup entry                       " -n; Write-Host -ForegroundColor White "$disabledefenderstart"
	Write-Host "Disable Toast notifications                          " -n; Write-Host -ForegroundColor White "$disablenotifs       "
	Write-Host "Disale Game Bar                                      " -n; Write-Host -ForegroundColor White "$disablegamebar      "
	Write-Host "Disale AutoPlay                                      " -n; Write-Host -ForegroundColor White "$disableautoplay     "
	Write-Host "Disale multi-monitor taskbar                         " -n; Write-Host -ForegroundColor White "$disablemultitaskbar "
	Write-Host "Disale Transparency                                  " -n; Write-Host -ForegroundColor White "$disabletransparency "
	Write-Host "Disale window animations                             " -n; Write-Host -ForegroundColor White "$disableanimations   "
	Write-Host "Disale Windows Ink Workspace (15063+)                " -n; Write-Host -ForegroundColor White "$disablewinink       "
	Write-Host "Remove Downloads folder (DANGEROUS)                  " -n; Write-Host -ForegroundColor White "$removedownloads     "
	Write-Host 'Disable "Look for this app in Store"                 ' -n; Write-Host -ForegroundColor White "$applookupinstore    "
	Write-Host "Tune the Context menu                                " -n; Write-Host -ForegroundColor White "$contextmenuentries  "
	Write-Host "Remove Quick Access*****                             " -n; Write-Host -ForegroundColor White "$removequickaccess   "
	Write-Host "Disable Location icon                                " -n; Write-Host -ForegroundColor White "$disablelocationicon "
	Write-Host "Activate Windows Photos viewer                       " -n; Write-Host -ForegroundColor White "$activatephotoviewer "
	Write-Host "Set Registered owner                                 " -n; Write-Host -ForegroundColor White "$registeredowner     "
	Write-Host "Enable Classic paint                                 " -n; Write-Host -ForegroundColor White "$classicpaint        "
	Write-Host "Disable Edge prelaunch on startup                    " -n; Write-Host -ForegroundColor White "$disableedgeprelaunch"
	Write-Host "Disable Cortana                                      " -n; Write-Host -ForegroundColor White "$disablecortana      "
	Write-Host "Disable automatic update of UWPs                     " -n; Write-Host -ForegroundColor White "$disablestoreautoupd "
	Write-Host "Enable classic ballon notifications                  " -n; Write-Host -ForegroundColor White "$balloonnotifs       "
	Write-Host "Show all icons in taskbar tray                       " -n; Write-Host -ForegroundColor White "$showalltrayicons    "
	Write-Host "Show hidden system files and folders                 " -n; Write-Host -ForegroundColor White "$showsuperhidden     "
	Write-Host "Disable Lock screen                                  " -n; Write-Host -ForegroundColor White "$disablelockscrn     "
	Write-Host "Use classic Alt+Tab                                  " -n; Write-Host -ForegroundColor White "$classicalttab       "
	Write-Host "Use classic volume control                           " -n; Write-Host -ForegroundColor White "$oldvolcontrol       "
	Write-Host "Set accent color to Default Blue                     " -n; Write-Host -ForegroundColor White "$defaultcolor        "
	Write-Host "Remove 3D objects (16299+)                           " -n; Write-Host -ForegroundColor White "$remove3Dobjects     "
	Write-Host "Hide Bluetooth icon                                  " -n; Write-Host -ForegroundColor White "$hidebluetoothicon   "
	Write-Host "Disable Login screen background                      " -n; Write-Host -ForegroundColor White "$disablelogonbg      "
	Write-Host "Remove Network icon from login screen                " -n; Write-Host -ForegroundColor White "$removelckscrneticon "
	Write-Host "Disable Power Throttling                             " -n; Write-Host -ForegroundColor White "$nopowerthrottling   "
	Write-Host "Reduce the amount of svchost.exes                    " -n; Write-Host -ForegroundColor White "$svchostslimming     "
	Write-Host " "
	Write-Host '***** This option will not work if "Default Explorer to This PC" is disabled.' -ForegroundColor Cyan
	Write-Host " "}
	Write-Host "You are now in Advanced configuration mode, where you can adjust individual functions of the script." -ForegroundColor Black -BackgroundColor Yellow
	Write-Host "Scroll up to the top and view the options." -ForegroundColor Yellow
}