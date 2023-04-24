$confuled = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ConfigSet
if ($confuled -eq 1) {exit}
Show-Branding clear
Start-Sleep -Seconds 1

function Show-ModulesConfig {
	Show-Branding clear
	Write-Host "------ SCRIPT CONFIGURATION: Module Switches ------" -ForegroundColor Black -BackgroundColor Green -n; Write-Host ([char]0xA0)
	Write-Host "Here's an overview of what the script will do to your PC" -ForegroundColor Green
	Write-Host " "; if ($pwsh -eq 7) {
	Write-Host "Run Windows Updates (14393+)                  " -n; Write-Host "$windowsupdate       "}; if ($pwsh -eq 5) {
	Write-Host "Install .NET 4.6.2 (10586-)                   " -n; Write-Host "$dotnet462           "}
	Write-Host "Enable .NET 3.5                               " -n; Write-Host "$dotnet35            "
	Write-Host "Install Essential Apps package**              " -n; Write-Host "$essentialapps       "
	Write-Host "Hide system icons from the taskbar            " -n; Write-Host "$hidetaskbaricons    "
	Write-Host "Remove Microsoft Edge Shortcuts               " -n; Write-Host "$removeedgeshortcut  "
	Write-Host "Create desktop shortcuts                      " -n; Write-Host "$desktopshortcuts    "
	Write-Host "Disable Wake timers                           " -n; Write-Host "$removewaketimers    "
	Write-Host "Remove all UWP apps possible                  " -n; Write-Host "$removeUWPapps       "
	Write-Host "Use script's Open-Shell config                " -n; Write-Host "$openshellconfig     "
	Write-Host "Replace Explorer taskbar icon (17763-)        " -n; Write-Host "$explorericon        "
	Write-Host "Remove taskbar pins                           " -n; Write-Host "$taskbarpins         "
	Write-Host "Replace seguiemj.ttf with Windows 11's        " -n; Write-Host "$replaceemojifont    "
	Write-Host "Set default apps                              " -n; Write-Host "$defaultapps         "
	Write-Host "Remove Explorer address bar                   " -n; Write-Host "$disableaddressbar   "
	Write-Host "Remove Microsoft OneDrive                     " -n; Write-Host "$removeonedrive      "
	Write-Host "Remove HomeGroup (16299-)                     " -n; Write-Host "$removehomegroup     "
	Write-Host "Defaults Explorer to This PC                  " -n; Write-Host "$explorerstartfldr   "
	Write-Host "Use classic battery flyout                    " -n; Write-Host "$oldbatteryflyout    "
	Write-Host "Install custom system sound                   " -n; Write-Host "$customsounds        "
	Write-Host "Disable some system apps                      " -n; Write-Host "$removesystemapps    "
	Write-Host "Replace SlideToShutDown.exe background        " -n; Write-Host "$sltoshutdownwall    "
	Write-Host "Don't touch Edge Chromium                     " -n; Write-Host "$keepedgechromium    "
	Write-Host " "
	Write-Host "------ SCRIPT CONFIGURATION: Registry Switches ------" -ForegroundColor Black -BackgroundColor Green -n; Write-Host ([char]0xA0)
	Write-Host " "        
	Write-Host "Enable registry tweaks                        " -n; Write-Host "$registrytweaks      "
	Write-Host " "
	Write-Host "Disable Defender startup entry                " -n; Write-Host "$disabledefenderstart"
	Write-Host "Disable Toast notifications                   " -n; Write-Host "$disablenotifs       "
	Write-Host "Disale Game Bar                               " -n; Write-Host "$disablegamebar      "
	Write-Host "Disale AutoPlay                               " -n; Write-Host "$disableautoplay     "
	Write-Host "Disale multi-monitor taskbar                  " -n; Write-Host "$disablemultitaskbar "
	Write-Host "Disale Transparency                           " -n; Write-Host "$disabletransparency "
	Write-Host "Disale window animations                      " -n; Write-Host "$disableanimations   "
	Write-Host "Disale Windows Ink Workspace (15063+)         " -n; Write-Host "$disablewinink       "
	Write-Host "Remove Downloads folder (DANGEROUS)           " -n; Write-Host "$removedownloads     "
	Write-Host 'Disable "Look for this app in Store"          ' -n; Write-Host "$applookupinstore    "
	Write-Host "Tune the Context menu                         " -n; Write-Host "$contextmenuentries  "
	Write-Host "Remove Quick Access                           " -n; Write-Host "$removequickaccess   "
	Write-Host "Disable Location icon***                      " -n; Write-Host "$disablelocationicon "
	Write-Host "Activate Windows Photos viewer                " -n; Write-Host "$activatephotoviewer "
	Write-Host "Set Registered owner                          " -n; Write-Host "$registeredowner     "
	Write-Host "Enable Classic paint                          " -n; Write-Host "$classicpaint        "
	Write-Host "Disable Edge prelaunch on startup             " -n; Write-Host "$disableedgeprelaunch"
	Write-Host "Disable Cortana                               " -n; Write-Host "$disablecortana      "
	Write-Host "Disable automatic update of UWPs              " -n; Write-Host "$disablestoreautoupd "
	Write-Host "Enable classic ballon notifications           " -n; Write-Host "$balloonnotifs       "
	Write-Host "Show all icons in taskbar tray                " -n; Write-Host "$showalltrayicons    "
	Write-Host "Disable Lock screen                           " -n; Write-Host "$disablelockscrn     "
	Write-Host "Use classic Alt+Tab                           " -n; Write-Host "$classicalttab       "
	Write-Host "Use classic volume control                    " -n; Write-Host "$oldvolcontrol       "
	Write-Host "Set accent color to Default Blue              " -n; Write-Host "$defaultcolor        "
	Write-Host "Remove 3D objects (16299+)                    " -n; Write-Host "$remove3Dobjects     "
	Write-Host "Hide Bluetooth icon                           " -n; Write-Host "$hidebluetoothicon   "
	Write-Host "Disable Login screen background               " -n; Write-Host "$disablelogonbg      "
	Write-Host "Remove Network icon from login screen         " -n; Write-Host "$removelckscrneticon "
	Write-Host "Reduce the amount of svchost.exes             " -n; Write-Host "$svchostslimming     "
	Write-Host "Enable ?????.???? desktop version             " -n; Write-Host "$desktopversion      "
	Write-Host " "
	Write-Host "Now please scroll up to the top and review the options." -ForegroundColor Black -BackgroundColor Yellow -n; Write-Host ([char]0xA0)
	Write-Host "UAC will be disabled immediately once you start the script."
}

function Start-InstallHikaru {
	Show-WindowTitle noclose
	Stop-Service -Name wuauserv -ErrorAction SilentlyContinue
	Write-Host " "
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling UAC" -n; Write-Host ([char]0xA0)
	Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name ConsentPromptBehaviorAdmin -Value 0 -Force
	Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name EnableLUA -Value 0 -Force
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing Hikaru-chan" -n; Write-Host ([char]0xA0)
	Copy-Item "$coredir\ambient\FFPlay.exe" -Destination "$env:SYSTEMDRIVE\Bionic\Hikaru"
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
	& $coredir\kernel\hikaru.ps1
	$setwallpaper = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SetWallpaper
	if ($keepedgechromium) {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "EdgeNoMercy" -Value 1 -Type DWord -Force
	} if ($setwallpaper -eq 1) {
		Copy-Item $workdir\utils\background.png -Destination "$env:SYSTEMDRIVE\Bionic\BioniDKU.png"
		& $workdir\modules\desktop\wallpaper.ps1
	} if ($explorerstartfldr) {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting Explorer to open on This PC" -n; Write-Host " (will take effect next time Explorer starts)"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Value 1 -Type DWord -Force
	} 
	$ngawarn = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).SkipNotGABWarn
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" -Name "DisableStartupSound" -Value 1 -Type DWord -Force
	if ($windowsupdate -and $ngawarn -ne 1) {
		# Take control over Windows Update so it doesn't do stupid, unless if it's Home or Server edition.
		if ($edition -notlike "Core" -or $edition -notlike "ServerStandard" -or $edition -notlike "ServerDatacenter") {
			Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Taking control over Windows Update" -n; Write-Host " (so it doesn't do stupid)" -ForegroundColor White
			switch ($build) {
				{$_ -ge 10240 -and $_ -le 19041} {$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ReleaseId}
				{$_ -ge 19042 -and $_ -le 19044} {$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion}
			}
			$wudir = (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate)
			if ($wudir -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name 'WindowsUpdate'}
			if ($build -ge 17134) {
				Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersionInfo' -Value $version -Type String -Force
				Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersion' -Value 1 -Type DWord -Force
			}
			$msrtdir = (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\MRT)
			if ($msrtdir -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Name 'MRT'}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name 'DontOfferThroughWUAU' -Value 1 -Type DWord -Force
			$noau = Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
			if ($noau -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name AU}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name AllowAutoUpdate -Value 5 -Type DWord -Force
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name AUOptions -Value 2 -Type DWord -Force
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAutoUpdate -Value 1 -Type DWord -Force
		}
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "WUmode" -Value 1 -Type DWord -Force
	}
	if ($essentialapps) {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "EssentialApps" -Value 1 -Type DWord -Force
	}
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 4 -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ChangesMade" -Value 1 -Type DWord -Force
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Restarting your device in 5 seconds... The script will start doing its job after the restart." -n; Write-Host ([char]0xA0)
	Start-Sleep -Seconds 5
	shutdown -r -t 0
	Start-Sleep -Seconds 30
	exit
}

function Confirm-DeleteDownloads {
	Write-Host -ForegroundColor Black -BackgroundColor Red "---------- HOLD UP! ---------" -n; Write-Host ([char]0xA0)
	Write-Host " "
	Write-Host -ForegroundColor Red 'You have selected to DELETE your Downloads folder during script exection. The script has deteced that you have files in this folder. Please back up anything necessary before proceeding any further.'
	Write-Host 'In addition, if this script is also running from within Downloads, please CLOSE it and move the whole folder to somewhere safe (I would suggest C:\). The script is currently being placed inside:'
	Write-Host -ForegroundColor Yellow "$wordkir"
	Write-Host 'If you do not want Downloads to get deleted, answer anything else except YES to go back, select 2 then 2 to reconfigure the script and set the' -n; Write-Host -ForegroundColor Cyan ' "Remove Downloads folder" ' -n; Write-Host 'switch to FALSE under the' -n; Write-Host -ForegroundColor Green ' "SCRIPT CONFIGURATION: Registry Switches" ' -n; Write-Host 'section.'
	Write-Host " "
	Write-Host -ForegroundColor Black -BackgroundColor Red "THIS IS YOUR LAST WARNING!!!" 
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

function Confirm-Wupdated {
	Write-Host " "
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Your build does not support Windows Update through PowerShell. Have you fully updated yet? (yes/no)"
	if ($build -eq 10240 -and $disablelockscrn) {Write-Host "On Windows 10 build 10240, updating is " -n; Write-Host "REQUIRED" -ForegroundColor Black -BackgroundColor Yellow -n; Write-Host " in order to be able to disable the LogonUI's background."}
	Write-Host "Your answer: " -n ; $fullyupdated = Read-Host
	switch ($fullyupdated) {
		{$fullyupdated -like "yes"} {
			Write-Host -ForegroundColor Green "Cool!"
		}
		{$fullyupdated -like "no"} {
			Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Then the script fell into darkness."
			Start-Sleep -Seconds 5
			Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 0 -Type DWord -Force
			exit
		}
		{$fullyupdated -like '*fuck*'} {
			Write-Host -ForegroundColor Red -BackgroundColor DarkGray "HAH, L"
			Start-Sleep -Seconds 2
			Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 0 -Type DWord -Force
			exit
		}
		{$fullyupdated -like 'Julia loves RTM'} {
			Write-Host -ForegroundColor Red -BackgroundColor DarkGray "Yes absolutely"
			Start-Sleep -Seconds 2
			Write-Host -ForegroundColor Red -BackgroundColor DarkGray "Wait, who asked? Read the question again you blind."
			Start-Sleep -Seconds 3
			Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 0 -Type DWord -Force
			exit
		}
		default {
			Write-Host -ForegroundColor Red -BackgroundColor DarkGray "You didn't answer appropriately. Exiting..."
			Start-Sleep -Seconds 2
			Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 0 -Type DWord -Force
			exit
		}
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

$confulee = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ConfigEditing
$confuone = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ChangesMade
if ($confulee -eq 2) {$confules = 2} elseif ($confulee -eq 3) {$confules = 3}
else {
	Write-Host -ForegroundColor Magenta "Welcome to BioniDKU!"
	Write-Host " "
	Write-Host -ForegroundColor Yellow "What do you want to do?"
	Write-Host -ForegroundColor White "1. Start the script"
	Write-Host -ForegroundColor White "2. Configure the script"
	Write-Host -ForegroundColor White "3. Customize your script running experience"
	Write-Host -ForegroundColor White "4. Show credits"
	if ($confuone -eq 0 -and $edition -like "Core") {
		Write-Host "Answer anything else to exit this script safely without any changes made to your PC."
		Write-Host "UAC will be disabled immediately once you start the script."
	} elseif ($confuone -eq 0) {
		Write-Host "Answer anything else to exit this script."
		Write-Host "UAC will be disabled immediately once you start the script."
	} else {
		Write-Host "Answer anything else to exit this script."
	}
	if (Get-RemoteSoftware) {
		Write-Host " "
		Write-Host "HINT: " -ForegroundColor Magenta -n; Write-Host "Running this remotely? " -ForegroundColor White -n; Write-Host 'Select 3 and enable "Increase wait time" to make your life easier!' -ForegroundColor Cyan
	}
	Write-Host " "
	Write-Host "Your selection: " -n ; $confules = Read-Host
}

switch ($confules) {
	{$_ -like "1"} {
		Write-Host " "
		$dlhasfiles = Test-Path -Path "$env:USERPROFILE\Downloads\*"
		if ($removedownloads -and $dlhasfiles) {
			Confirm-DeleteDownloads
		} if ($pwsh -eq 5) {
			Confirm-Wupdated
		}
		Write-Host " "
		Start-Process "$coredir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $coredir\ambient\DomainAccepted.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
		Write-Host -ForegroundColor Green "You have accepted the current configuration. Alright, starting the script..."
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 1 -Type DWord -Force
		Start-Sleep -Seconds 5
		Start-InstallHikaru
	}
	{$_ -like "2"} {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 2 -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditing" -Value 2 -Type DWord -Force
		Show-ModulesConfig
		Write-Host -ForegroundColor Yellow "Then, select the following actions:"
		Write-Host -ForegroundColor White "1. Open the script in Notepad to reconfigure the options,"
		Write-Host -ForegroundColor White "   it will wait for you and refresh once you close Notepad"
		Write-Host -ForegroundColor White "0. Accept the current configuration and return to main menu"
		Write-Host " "
		Write-Host "Your selection: " -n ; $confulee = Read-Host
		switch ($confulee) {
			{$_ -like "1"} {
				Write-Host -ForegroundColor Cyan "Now opening $PSScriptRoot\config.ps1 in Notepad"
				#Write-Host -ForegroundColor Cyan "(Please make sure that you do not have any Notepad window opened right now!)"
				Write-Host -ForegroundColor Cyan "Once you close Notepad, this screen will refresh with your changes"
				Start-Process notepad.exe -Wait -NoNewWindow -ArgumentList "$PSScriptRoot\config.ps1"
				exit
			}
			{$_ -like "0"} {
				Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditing" -Value 0 -Type DWord -Force
				exit
			} default {
				exit
			}
		}
	}
	{$_ -like "3"} {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 2 -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditing" -Value 3 -Type DWord -Force
		Show-Branding clear
		Write-Host -ForegroundColor Magenta "Welcome to BioniDKU!"
		$setwallpaper = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SetWallpaper
		$setupmusic = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic
		$increasewait = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").RunningThisRemotely
		Write-Host " "
		Write-Host -ForegroundColor Yellow "To customize your script running experience, tune the following options to your desire."
		Write-Host -ForegroundColor White "1. Set desktop wallpaper to the one from the script" -n; Show-Disenabled $setwallpaper
		Write-Host -ForegroundColor White "2. Toggle background music" -n; Show-Disenabled $setupmusic
		Write-Host -ForegroundColor White "3. Increase wait time (ideal for remote setups)" -n; Show-Disenabled $increasewait
		if ($setupmusic -eq 1) {Write-Host -ForegroundColor White "4. Customize your music selection"}
		Write-Host -ForegroundColor White "0. Accept the current configuration and return to main menu"
		Write-Host " "
		Write-Host "Your selection: " -n ; $confulee = Read-Host
		switch ($confulee) {
			{$_ -like "1"} {Select-Disenabled SetWallpaper; exit}
			{$_ -like "2"} {Select-Disenabled HikaruMusic; exit}
			{$_ -like "3"} {Select-Disenabled RunningThisRemotely; exit}
			{$_ -like "4"} {if ($setupmusic -eq 1) {& $workdir\music\musicp.ps1}; exit}
			{$_ -like "0"} {
				Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditing" -Value 0 -Type DWord -Force
				exit
			}
		}
	}
	{$_ -like "4"} {
		& $PSScriptRoot\credits.ps1
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 2 -Type DWord -Force
		exit
	}
	default {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 0 -Type DWord -Force
		exit
	}
}
