# BioniDKU main menu - The thing that appears on first run of the script

function Show-ModulesConfig {
	Show-Branding clear
	Write-Host "------ ADVANCED SCRIPT CONFIGURATION: Module Switches ------" -ForegroundColor Black -BackgroundColor Green
	Write-Host 'BioniDKU is a script bundle consisting multiple script files, called "(BioniDKU) Modules".' -ForegroundColor Green
	Write-Host 'Below are most of the function modules you can adjust, each should be self-explainatory:' -ForegroundColor Green
	Write-Host " "; if ($pwsh -eq 5) {
	Write-Host "Install .NET 4.6.2 (10586-)                   " -n; Write-Host -ForegroundColor White "$dotnet462           "}
	Write-Host "Enable .NET 3.5                               " -n; Write-Host -ForegroundColor White "$dotnet35            "
	Write-Host "Hide system icons from the taskbar            " -n; Write-Host -ForegroundColor White "$hidetaskbaricons    "
	Write-Host "Remove Microsoft Edge Shortcuts**             " -n; Write-Host -ForegroundColor White "$removeedgeshortcut  "
	Write-Host "Create desktop shortcuts                      " -n; Write-Host -ForegroundColor White "$desktopshortcuts    "
	Write-Host "Disable Wake timers                           " -n; Write-Host -ForegroundColor White "$removewaketimers    "
	Write-Host "Remove all UWP apps possible                  " -n; Write-Host -ForegroundColor White "$removeUWPapps       "
	Write-Host "Use script's Open-Shell config*               " -n; Write-Host -ForegroundColor White "$openshellconfig     "
	Write-Host "Replace Explorer taskbar icon (17763-)        " -n; Write-Host -ForegroundColor White "$explorericon        "
	Write-Host "Remove taskbar pins                           " -n; Write-Host -ForegroundColor White "$taskbarpins         "
	Write-Host "Replace seguiemj.ttf with Windows 11's        " -n; Write-Host -ForegroundColor White "$replaceemojifont    "
	Write-Host "Set default apps                              " -n; Write-Host -ForegroundColor White "$defaultapps         "
	Write-Host "Remove Explorer address bar                   " -n; Write-Host -ForegroundColor White "$disableaddressbar   "
	Write-Host "Remove Microsoft OneDrive                     " -n; Write-Host -ForegroundColor White "$removeonedrive      "
	Write-Host "Remove HomeGroup (16299-)                     " -n; Write-Host -ForegroundColor White "$removehomegroup     "
	Write-Host "Defaults Explorer to This PC                  " -n; Write-Host -ForegroundColor White "$explorerstartfldr   "
	Write-Host "Use classic battery flyout                    " -n; Write-Host -ForegroundColor White "$oldbatteryflyout    "
	Write-Host "Install custom system sound                   " -n; Write-Host -ForegroundColor White "$customsounds        "
	Write-Host "Disable some system apps**                    " -n; Write-Host -ForegroundColor White "$removesystemapps    "
	Write-Host "Replace SlideToShutDown.exe background        " -n; Write-Host -ForegroundColor White "$sltoshutdownwall    "
	Write-Host "Don't touch Edge Chromium**                   " -n; Write-Host -ForegroundColor White "$keepedgechromium    "
	Write-Host "Keep Windows Search**                         " -n; Write-Host -ForegroundColor White "$keepsearch          "
	Write-Host " "
	Write-Host " * You MUST enable the installation of Essential Apps or this option will disable itself" -ForegroundColor Cyan
	Write-Host "** If you enable these option, other options with ** will be affected" -ForegroundColor Cyan
	Write-Host " "
	Write-Host "------ ADVANCED SCRIPT CONFIGURATION: Registry Switches ------" -ForegroundColor Black -BackgroundColor Green
	Write-Host " "
	Write-Host "Enable registry tweaks                        " -n; Write-Host -ForegroundColor White "$registrytweaks      "
	Write-Host " "
	Write-Host "Disable Defender startup entry                " -n; Write-Host -ForegroundColor White "$disabledefenderstart"
	Write-Host "Disable Toast notifications                   " -n; Write-Host -ForegroundColor White "$disablenotifs       "
	Write-Host "Disale Game Bar                               " -n; Write-Host -ForegroundColor White "$disablegamebar      "
	Write-Host "Disale AutoPlay                               " -n; Write-Host -ForegroundColor White "$disableautoplay     "
	Write-Host "Disale multi-monitor taskbar                  " -n; Write-Host -ForegroundColor White "$disablemultitaskbar "
	Write-Host "Disale Transparency                           " -n; Write-Host -ForegroundColor White "$disabletransparency "
	Write-Host "Disale window animations                      " -n; Write-Host -ForegroundColor White "$disableanimations   "
	Write-Host "Disale Windows Ink Workspace (15063+)         " -n; Write-Host -ForegroundColor White "$disablewinink       "
	Write-Host "Remove Downloads folder (DANGEROUS)           " -n; Write-Host -ForegroundColor White "$removedownloads     "
	Write-Host 'Disable "Look for this app in Store"          ' -n; Write-Host -ForegroundColor White "$applookupinstore    "
	Write-Host "Tune the Context menu                         " -n; Write-Host -ForegroundColor White "$contextmenuentries  "
	Write-Host "Remove Quick Access                           " -n; Write-Host -ForegroundColor White "$removequickaccess   "
	Write-Host "Disable Location icon                         " -n; Write-Host -ForegroundColor White "$disablelocationicon "
	Write-Host "Activate Windows Photos viewer                " -n; Write-Host -ForegroundColor White "$activatephotoviewer "
	Write-Host "Set Registered owner                          " -n; Write-Host -ForegroundColor White "$registeredowner     "
	Write-Host "Enable Classic paint                          " -n; Write-Host -ForegroundColor White "$classicpaint        "
	Write-Host "Disable Edge prelaunch on startup             " -n; Write-Host -ForegroundColor White "$disableedgeprelaunch"
	Write-Host "Disable Cortana                               " -n; Write-Host -ForegroundColor White "$disablecortana      "
	Write-Host "Disable automatic update of UWPs              " -n; Write-Host -ForegroundColor White "$disablestoreautoupd "
	Write-Host "Enable classic ballon notifications           " -n; Write-Host -ForegroundColor White "$balloonnotifs       "
	Write-Host "Show all icons in taskbar tray                " -n; Write-Host -ForegroundColor White "$showalltrayicons    "
	Write-Host "Show hidden system files and folders          " -n; Write-Host -ForegroundColor White "$showsuperhidden     "
	Write-Host "Disable Lock screen                           " -n; Write-Host -ForegroundColor White "$disablelockscrn     "
	Write-Host "Use classic Alt+Tab                           " -n; Write-Host -ForegroundColor White "$classicalttab       "
	Write-Host "Use classic volume control                    " -n; Write-Host -ForegroundColor White "$oldvolcontrol       "
	Write-Host "Set accent color to Default Blue              " -n; Write-Host -ForegroundColor White "$defaultcolor        "
	Write-Host "Remove 3D objects (16299+)                    " -n; Write-Host -ForegroundColor White "$remove3Dobjects     "
	Write-Host "Hide Bluetooth icon                           " -n; Write-Host -ForegroundColor White "$hidebluetoothicon   "
	Write-Host "Disable Login screen background               " -n; Write-Host -ForegroundColor White "$disablelogonbg      "
	Write-Host "Remove Network icon from login screen         " -n; Write-Host -ForegroundColor White "$removelckscrneticon "
	Write-Host "Reduce the amount of svchost.exes             " -n; Write-Host -ForegroundColor White "$svchostslimming     "
	Write-Host "Enable ?????.???? desktop version             " -n; Write-Host -ForegroundColor White "$desktopversion      "
	Write-Host " "
	Write-Host "You are now in Advanced configuration mode, where you can adjust individual functions of the script." -ForegroundColor Black -BackgroundColor Yellow
	Write-Host "Scroll up to the top and view the options." -ForegroundColor Yellow
}

function Start-InstallHikaru {
	& $coredir\kernel\getready.ps1
}

function Confirm-DeleteDownloads {
	Write-Host -ForegroundColor Black -BackgroundColor Red "---------- HOLD UP! ---------"
	Write-Host " "
	Write-Host -ForegroundColor Red 'You have selected to DELETE your Downloads folder during script exection. The script has deteced that you have files in this folder. Please back up anything necessary before proceeding any further.'
	Write-Host 'In addition, if this script is also running from within Downloads, please CLOSE it and move the whole folder to somewhere safe (I would suggest C:\). The script is currently being placed inside:'
	Write-Host -ForegroundColor Yellow "$workdir"
	Write-Host 'If you do not want Downloads to get deleted, answer anything else except YES to go back, select 2 then 2 to reconfigure the script and set the' -n; Write-Host -ForegroundColor Cyan ' "Remove Downloads folder" ' -n; Write-Host 'switch to FALSE under the' -n; Write-Host -ForegroundColor Green ' "SCRIPT CONFIGURATION: Registry Switches" ' -n; Write-Host 'section.'
	Write-Host " "
	Write-Host -ForegroundColor Black -BackgroundColor Red "THIS IS YOUR LAST WARNING!!!" 
	Write-Host -ForegroundColor Cyan "If you are sure and want to proceed, answer YES."
	Write-Host "Your answer: " -n ; $deload = Read-Host
	switch ($deload) {
		{$deload -like "yes"} {}
		default {
			Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 3 -Type DWord -Force
			exit
		}
	}
}

function Confirm-Wupdated {
	switch ($build) {
		{$_ -eq 10240} {$mrubr = 17394; if ($ubr -ge $mrubr) {return $true} else {return $false}}
		{$_ -eq 10586} {$mrubr =  1176; if ($ubr -ge $mrubr) {return $true} else {return $false}}
		default {return $true}
	}
}

function Show-Disenabled($regvalue) {
	if ($regvalue -eq 1) {
		Write-Host -ForegroundColor Green " (ENABLED)"
	} else {
		Write-Host -ForegroundColor Red " (DISABLED)"
	}
}

function Select-Disenabled($regvalue) {
	$regreturns = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").$regvalue
	if ($regreturns -eq 1) {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name $regvalue -Value 0 -Type DWord -Force
	} else {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name $regvalue -Value 1 -Type DWord -Force
	}
}

function Get-RemoteSoftware {
	# Right now, only AnyDesk and Parsec are supported
	$anydesk = Test-Path -Path "$env:SYSTEMDRIVE\Program Files (x86)\AnyDesk\AnyDesk.exe"
	$rustdesk = Test-Path -Path "$env:SYSTEMDRIVE\Program Files\RustDesk\RustDesk.exe"
	$anydeskon = Get-Process AnyDesk -ErrorAction SilentlyContinue
	$rustdeskon = Get-Process RustDesk -ErrorAction SilentlyContinue
	if ($anydesk -or $rustdesk -or $anydeskon -or $rustdeskon) {
		return $true
	} else {return $false}
}

function Check-EnoughActions {
	switch ($true) {
		$hidetaskbaricons {}
		$removeonedrive {}  
		{$removehomegroup -eq $true -and $build -lt 17134} {}
		$desktopshortcuts {}
		{$essentialapps -eq 1} {}
		$openshellconfig {}
		$removewaketimers {}
		$removeUWPapps {}
		$taskbarpins {}
		$explorericon {}
		$disableaddressbar {}
		$oldbatteryflyout {}
		$registrytweaks {}
		$customsounds {}
		$replaceemojifont {}
		$removeedgeshortcut {}
		$removesystemapps {}
		$sltoshutdownwall {}
		default {
			return $false
		}
	}
}

$confulee = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ConfigEditing
$confuone = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ChangesMade
if ($confulee -eq 2) {$confules = 2} elseif ($confulee -eq 3) {$confules = 3}
else {
	$snareason1 = " - For this version of Windows 10, you must be running at least build $build.$mrubr in order to execute this script.`r`n   Please update your device and try again."
	$snareason2 = " - You did not select enough options in Advanced script configuration to proceed.`r`n   Try select a few more options, and try again."
	switch ($false) {
		{(Confirm-Wupdated) -eq $_} {$snarscode = 1; $startallowed = $false}
		{(Check-EnoughActions) -eq $_} {$snarscode = 2; $startallowed = $false}
		{(Confirm-Wupdated) -eq $_ -and (Check-EnoughActions) -eq $_} {$snarscode = 3; $startallowed = $false}
		default {$startallowed = $true}
	}
	Show-Branding clear
	Write-Host -ForegroundColor White "You're running Windows $editiontype $editiond, OS build"$build"."$ubr
	Write-Host -ForegroundColor Magenta "Welcome to BioniDKU!"
	switch ($startallowed) {
		{$_ -eq $false} {
			$stcolor = "DarkGray" 
			Write-Host " "
			Write-Host -ForegroundColor Red "DENIED: Starting the script is currently not allowed due to the following reasons:"
			switch ($snarscode) {
				{$_ -eq 1} {Write-Host -ForegroundColor Red "$snareason1"}
				{$_ -eq 2} {Write-Host -ForegroundColor Red "$snareason2"}
				{$_ -eq 3} {Write-Host -ForegroundColor Red "${snareason1}`r`n${snareason2}"}
			}
		}
		{$_ -eq $true} {
			$stcolor = "White"
		}
	}
	if (Get-RemoteSoftware) {
		Write-Host " "
		Write-Host "HINT: " -ForegroundColor Magenta -n; Write-Host "Running this remotely? " -ForegroundColor White -n; Write-Host 'Select 2 and enable "Increase wait time" to make your life easier!' -ForegroundColor Cyan
	}
	Write-Host " "
	Write-Host -ForegroundColor Yellow "What do you want to do?"
	Write-Host -ForegroundColor $stcolor "1. Start the script"
	Write-Host -ForegroundColor White "2. Configure the script"
	Write-Host -ForegroundColor White "3. Enter advanced script configuration"
	Write-Host -ForegroundColor White "4. Show credits"
	if ($confuone -eq 0) {
		Write-Host "Answer anything else to exit this script safely without any changes made to your PC."
		Write-Host "UAC will be disabled immediately once you start the script." -ForegroundColor Red
	} else {
		Write-Host "Answer anything else to exit this script."
	}
	Write-Host " "
	Write-Host "Your selection: " -n ; $confules = Read-Host
}

switch ($confules) {
	{$_ -like "1"} {
		Write-Host " "
		if ($startallowed -eq $false) {
			Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 3 -Type DWord -Force
			exit
		}
		if ($build -lt 14393) {& $workdir\core\kernel\confirmwupdated.ps1}
		$dlhasfiles = Test-Path -Path "$env:USERPROFILE\Downloads\*"
		if ($removedownloads -and $dlhasfiles) {
			Confirm-DeleteDownloads
		}
		Write-Host " "
		Start-Process "$coredir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $coredir\ambient\DomainAccepted.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
		Write-Host -ForegroundColor Green -BackgroundColor DarkGray "You have accepted the current configuration. Alright, starting the script..."
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 1 -Type DWord -Force
		Start-Sleep -Seconds 5
		Start-InstallHikaru
	}
	{$_ -like "2"} {
		$confuleb = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).ConfigEditingSub
		if ($confuleb -eq 7) {& $workdir\modules\apps\appspicker.ps1; exit}
		if ($confuleb -eq 5) {& $workdir\music\musicpicker.ps1; exit}
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 3 -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditing" -Value 2 -Type DWord -Force
		Show-Branding clear
		Write-Host -ForegroundColor Magenta "Welcome to BioniDKU!"
		$setwallpaper = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SetWallpaper
		$setupmusic = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic
		$increasewait = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").RunningThisRemotely
		$essentialapps = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").EssentialApps
		$windowsupdatesw = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").WUmodeSwitch
		if ($pwsh -eq 5) {$wucolor = "DarkGray"} else {$wucolor = "White"}
		Write-Host " "
		Write-Host -ForegroundColor Yellow "Configure the script by tuning the following options to your desire."
		Write-Host -ForegroundColor $wucolor "1. Toggle Windows Update mode" -n; if ($pwsh -eq 7) {Show-Disenabled $windowsupdatesw} else {Write-Host " "}
		Write-Host -ForegroundColor White "2. Set desktop wallpaper to the one from the script" -n; Show-Disenabled $setwallpaper
		Write-Host -ForegroundColor White "3. Increase wait time (ideal for remote setups)" -n; Show-Disenabled $increasewait
		Write-Host -ForegroundColor White "4. Toggle background music" -n; Show-Disenabled $setupmusic
		if ($setupmusic -eq 1) {Write-Host -ForegroundColor White "5. Customize your music selection"}
		Write-Host -ForegroundColor White "6. Toggle the installation of Essential Apps" -n; Show-Disenabled $essentialapps
		if ($essentialapps -eq 1) {Write-Host -ForegroundColor White "7. Customize which Apps to install"}
		Write-Host -ForegroundColor White "0. Accept the current configuration and return to main menu"
		Write-Host " "
		Write-Host "Your selection: " -n ; $confulee = Read-Host
		switch ($confulee) {
			{$_ -like "1"} {if ($pwsh -eq 7) {Select-Disenabled WUmodeSwitch}; exit}
			{$_ -like "2"} {Select-Disenabled SetWallpaper; exit}
			{$_ -like "3"} {Select-Disenabled RunningThisRemotely; exit}
			{$_ -like "4"} {Select-Disenabled HikaruMusic; exit}
			{$_ -like "5"} {if ($setupmusic -eq 1) {& $workdir\music\musicpicker.ps1}; exit}
			{$_ -like "6"} {Select-Disenabled EssentialApps; exit}
			{$_ -like "7"} {if ($essentialapps -eq 1) {& $workdir\modules\apps\appspicker.ps1}; exit}
			{$_ -like "0"} {
				Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditing" -Value 0 -Type DWord -Force
				exit
			}
		}
	}
	{$_ -like "3"} {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 3 -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditing" -Value 3 -Type DWord -Force
		Show-ModulesConfig
		Write-Host -ForegroundColor Yellow "Then, select the following actions:"
		Write-Host -ForegroundColor White "1. Open the script in Notepad to reconfigure the options,"
		Write-Host -ForegroundColor White "   it will wait for you and refresh once you close Notepad"
		Write-Host -ForegroundColor White "0. Accept the current configuration and return to main menu" -n; Write-Host " (Default answer)"
		Write-Host " "
		Write-Host "Your selection: " -n ; $confulee = Read-Host
		switch ($confulee) {
			{$_ -like "1"} {
				Write-Host -ForegroundColor Cyan "Now opening $PSScriptRoot\config.ps1 in Notepad"
				Write-Host -ForegroundColor Cyan "Once you close Notepad, this screen will refresh with your changes"
				Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 2 -Type DWord -Force
				Start-Process notepad.exe -Wait -NoNewWindow -ArgumentList "$PSScriptRoot\config.ps1"
				exit
			}
			default {
				Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditing" -Value 0 -Type DWord -Force
				exit
			}
		}
	}
	{$_ -like "4"} {
		& $PSScriptRoot\credits.ps1
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 3 -Type DWord -Force
		exit
	}
	default {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 0 -Type DWord -Force
		exit
	}
}
