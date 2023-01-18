$confuled = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ConfigSet
if ($confuled -eq 1) {exit}
Show-Branding clear creds
Start-Sleep -Seconds 1

function Show-ModulesConfig {
	Show-Branding clear
	Write-Host "------ SCRIPT CONFIGURATION: Module Switches ------" -ForegroundColor Black -BackgroundColor Green -n; Write-Host ([char]0xA0)
	Write-Host "Here's an overview of what the script will do to your PC" -ForegroundColor Green
	Write-Host " "
	Write-Host "setupmusic                     " -n; Write-Host "$setupmusic        "
	Write-Host " "
	Write-Host "requiredprograms               " -n; Write-Host "$requiredprograms  "
	Write-Host "hidetaskbaricons               " -n; Write-Host "$hidetaskbaricons  "
	Write-Host "replaceneticon                 " -n; Write-Host "$replaceneticon    "
	Write-Host "removeedge                     " -n; Write-Host "$removeedge        " 
	if ($pwsh -eq 7) {Write-Host "windowsupdate                  " -n; Write-Host "$windowsupdate     "}
	Write-Host "setwallpaper                   " -n; Write-Host "$setwallpaper      "
	Write-Host "dotnet35                       " -n; Write-Host "$dotnet35          " 
	if ($pwsh -eq 5) {Write-Host "dotnet462                      " -n; Write-Host "$dotnet462         "}
	Write-Host "sharex462                      " -n; Write-Host "$sharex462         "
	Write-Host "paintdotnet462                 " -n; Write-Host "$paintdotnet462    "
	Write-Host "desktopshortcuts               " -n; Write-Host "$desktopshortcuts  "
	Write-Host "removeudpassistant             " -n; Write-Host "$removeudpassistant"
	Write-Host "removewaketimers               " -n; Write-Host "$removewaketimers  "
	Write-Host "removeUWPapps                  " -n; Write-Host "$removeUWPapps     "
	Write-Host "openshellconfig                " -n; Write-Host "$openshellconfig   "
	Write-Host "explorericon                   " -n; Write-Host "$explorericon      "
	Write-Host "classicapps                    " -n; Write-Host "$classicapps       "
	Write-Host "taskbarpins                    " -n; Write-Host "$taskbarpins       "
	Write-Host "replaceemojifont               " -n; Write-Host "$replaceemojifont  "
	Write-Host "defaultapps                    " -n; Write-Host "$defaultapps       "
	Write-Host "disablesettings                " -n; Write-Host "$disablesettings   "
	Write-Host "blockapps                      " -n; Write-Host "$blockapps         "
	Write-Host "gpomodifs                      " -n; Write-Host "$gpomodifs         "
	Write-Host "disableaddressbar              " -n; Write-Host "$disableaddressbar "
	Write-Host "removeonedrive                 " -n; Write-Host "$removeonedrive    "
	Write-Host "removehomegroup                " -n; Write-Host "$removehomegroup   "
	Write-Host "explorerstartfldr              " -n; Write-Host "$explorerstartfldr "
	Write-Host "oldbatteryflyout               " -n; Write-Host "$oldbatteryflyout  "
	Write-Host "customsounds                   " -n; Write-Host "$customsounds      "
	Write-Host " "
	Write-Host "------ SCRIPT CONFIGURATION: Registry Switches ------" -ForegroundColor Black -BackgroundColor Green -n; Write-Host ([char]0xA0)
	Write-Host "More details about what these options are for in the script file" -ForegroundColor Green
	Write-Host " "        
	Write-Host "registrytweaks                 " -n; Write-Host "$registrytweaks"
	Write-Host " "
	Write-Host "disablestartupitems            " -n; Write-Host "$disablestartupitems "
	Write-Host "disablenotifs                  " -n; Write-Host "$disablenotifs       "
	Write-Host "disablegamebar                 " -n; Write-Host "$disablegamebar      "
	Write-Host "disableautoplay                " -n; Write-Host "$disableautoplay     "
	Write-Host "disablemultitaskbar            " -n; Write-Host "$disablemultitaskbar "
	Write-Host "transparencydisable            " -n; Write-Host "$transparencydisable "
	Write-Host "disableanimations              " -n; Write-Host "$disableanimations   "
	Write-Host "disablewinink                  " -n; Write-Host "$disablewinink       "
	Write-Host "removedownloads                " -n; Write-Host "$removedownloads     "
	Write-Host "applookupinstore               " -n; Write-Host "$applookupinstore    "
	Write-Host "contextmenuentries             " -n; Write-Host "$contextmenuentries  "
	Write-Host "1709peoplebar                  " -n; Write-Host "$1709peoplebar       "
	Write-Host "1511locationicon               " -n; Write-Host "$1511locationicon    "
	Write-Host "removequickaccess              " -n; Write-Host "$removequickaccess   "
	Write-Host "disablelocationicon            " -n; Write-Host "$disablelocationicon "
	Write-Host "activatephotoviewer            " -n; Write-Host "$activatephotoviewer "
	Write-Host "registeredowner                " -n; Write-Host "$registeredowner     "
	Write-Host "classicpaint                   " -n; Write-Host "$classicpaint        "
	Write-Host "disableedgeprelaunch           " -n; Write-Host "$disableedgeprelaunch"
	Write-Host "disablecortana                 " -n; Write-Host "$disablecortana      "  
	Write-Host "disablestoreautoupd            " -n; Write-Host "$disablestoreautoupd "
	Write-Host "balloonnotifs                  " -n; Write-Host "$balloonnotifs       "   
	Write-Host "showalltrayicons               " -n; Write-Host "$showalltrayicons    "
	Write-Host "disablelockscrn                " -n; Write-Host "$disablelockscrn     " 
	Write-Host "darkmodeoff                    " -n; Write-Host "$darkmodeoff         "     
	Write-Host "classicalttab                  " -n; Write-Host "$classicalttab       "   
	Write-Host "oldvolcontrol                  " -n; Write-Host "$oldvolcontrol       "   
	Write-Host "defaultcolor                   " -n; Write-Host "$defaultcolor        "    
	Write-Host "remove3Dobjects                " -n; Write-Host "$remove3Dobjects     " 
	Write-Host "hidebluetoothicon              " -n; Write-Host "$hidebluetoothicon   "
	Write-Host "disablelogonbg                 " -n; Write-Host "$disablelogonbg      "  
	Write-Host "svchostslimming                " -n; Write-Host "$svchostslimming     " 
	Write-Host " "
	Write-Host "Now please scroll up to the top and review the options." -ForegroundColor Black -BackgroundColor Yellow -n; Write-Host ([char]0xA0)
	Write-Host "UAC will be disabled immediately once you start the script."
}

function Start-InstallHikaru {
	Write-Host " "
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling UAC" -n; Write-Host ([char]0xA0)
    Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name ConsentPromptBehaviorAdmin -Value 0
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing Hikaru-chan" -n; Write-Host ([char]0xA0)
	Expand-Archive -Path $workdir\utils\Hikaru.zip -DestinationPath $env:SYSTEMDRIVE\Bionic\Hikaru
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
	& $PSScriptRoot\hikaru.ps1
	if ($setwallpaper -eq $true) {
		& $PSScriptRoot\..\modules\desktop\wallpaper.ps1
	} if ($setupmusic -eq $true) {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMusic" -Value 1 -Type DWord -Force
	} if ($windowsupdate -eq $true) {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing PSWindowsUpdate" -n; Write-Host ([char]0xA0)
		Install-PackageProvider -Name "NuGet" -Verbose -Force
		Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
		Add-Type -AssemblyName presentationCore
        Install-Module PSWindowsUpdate
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 2 -Type DWord -Force
	}
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ChangesMade" -Value 1 -Type DWord -Force
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Restarting your device in 5 seconds... The script will start doing its job after the restart." -n; Write-Host ([char]0xA0)
	Start-Sleep -Seconds 5
	shutdown -r -t 0
	Start-Sleep -Seconds 30
	exit
}

$confulee = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ConfigEditing
$confuone = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ChangesMade
if ($confulee -eq 1) {
	$confules = 2
} else {
	Write-Host -ForegroundColor Magenta "Welcome to BioniDKU!"
	Write-Host " "
	Write-Host -ForegroundColor Yellow "What do you want to do?"
	Write-Host -ForegroundColor White "1. Start the script with the default options"
	Write-Host -ForegroundColor White "2. Configure options"
	if ($confuone -eq 0) {
		Write-Host "Answer anything else to exit this script safely without any changes made to your PC" 
		Write-Host "(except with PowerShell 7 installed)"
		Write-Host "UAC will be disabled immediately once you start the script."
		Write-Host " "
		Write-Host "Your selection: " -n ; $confules = Read-Host
	} else {
		Write-Host "Answer anything else to exit this script"
		Write-Host " "
		Write-Host "Your selection: " -n ; $confules = Read-Host
	}
}

switch ($confules) {
	{$confules -like "1"} {
		Write-Host " "
		$dlhasfiles = Test-Path -Path "$env:USERPROFILE\Downloads\*"
		if ($removedownloads -eq $true -and $dlhasfiles -eq $true) {
			Write-Host -ForegroundColor Black -BackgroundColor Red "---------- HOLD UP! ---------" -n; Write-Host ([char]0xA0)
			Write-Host -ForegroundColor Red "You have selected to DELETE your Downloads folder during script exection. The script has deteced that you have files in this folder. Please back up anything necessary before proceeding any further." 
			Write-Host 'In addition, if this script is also running from within Downloads, please CLOSE it and move the whole folder to somewhere safe (I would suggest C:\). The script is currently being placed inside (the parent folder of "core"):'
			Write-Host -ForegroundColor Yellow "$PSScriptRoot"
			Write-Host "If you do not want Downloads to get deleted, answer anything else except YES to go back, select 2 then 2 to reconfigure the script and set the switch to FALSE under the SCRIPT CONFIGURATION: Registry Switches section."
			Write-Host -ForegroundColor Red "THIS IS YOUR LAST WARNING!!!" 
			Write-Host -ForegroundColor Cyan "If you are sure and want to proceed, answer YES."
			Write-Host "Your answer: " -n ; $deload = Read-Host
			switch ($deload) {
				{$deload -like "yes"} {}
				default {
					Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 2 -Type DWord -Force
					Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 1 -Type DWord -Force
					exit
				}
			}
		}
		Write-Host " "
		Write-Host -ForegroundColor Green "You have accepted the current configuration. Alright, starting the script..."
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 1 -Type DWord -Force
		Start-Sleep -Seconds 5
		Start-InstallHikaru
	}
	{$confules -like "2"} {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditing" -Value 1 -Type DWord -Force
		Show-ModulesConfig
		Write-Host -ForegroundColor Yellow "Then, select the following actions:"
		Write-Host -ForegroundColor White "1. Accept the current configuration and reload the script"
		Write-Host -ForegroundColor White "2. Open the script in Notepad to reconfigure the options,"
		Write-Host -ForegroundColor White "   it will wait for you and reload once you close Notepad"
		Write-Host " "
		Write-Host "Your selection: " -n ; $confulee = Read-Host
		switch ($confulee) {
			{$confulee -like "2"} {
				Write-Host -ForegroundColor Cyan "Now opening $PSScriptRoot\main.ps1 in Notepad"
				Write-Host -ForegroundColor Cyan "(Please make sure that you do not have any Notepad window opened right now!)"
				Write-Host -ForegroundColor Cyan "Once you close Notepad, the script will reload with your changes"
				Start-Process notepad.exe -Wait -NoNewWindow -ArgumentList "$PSScriptRoot\main.ps1"
				Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 2 -Type DWord -Force
				exit
			}
			{$confulee -like "1"} {
				Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditing" -Value 0 -Type DWord -Force
				Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 2 -Type DWord -Force
				exit
			}
	}
	default {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 0 -Type DWord -Force
		exit
	}
}
}