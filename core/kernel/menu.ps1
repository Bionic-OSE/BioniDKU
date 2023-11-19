# BioniDKU main menu - The thing that appears on first run of the script

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
function Show-WelcomeText {
	Write-Host -ForegroundColor White "You're running Windows $editiontype $editiond, OS build"$build"."$ubr
	Write-Host -ForegroundColor Magenta "Welcome to BioniDKU!"
}
function Confirm-DeleteDownloads {
	Write-Host -ForegroundColor Black -BackgroundColor Red "---------- HOLD UP ----------"
	Write-Host " "
	Write-Host -ForegroundColor Red 'You have selected to DELETE your Downloads folder during script exection. The script has deteced that you have files in this folder. Please back up anything necessary before proceeding any further.'
	Write-Host "In addition, if this script is also running from within Downloads, please CLOSE it and move the whole folder to somewhere safe (I would suggest $env:SYSTEMDRIVE\). The script is currently being placed inside:"
	Write-Host -ForegroundColor Yellow "$workdir"
	Write-Host 'If you do not want Downloads to get deleted, answer anything else except YES to go back, select 3 then 1 to reconfigure the script and set the' -n; Write-Host -ForegroundColor Cyan ' "Remove Downloads folder" ' -n; Write-Host 'switch to FALSE under the' -n; Write-Host -ForegroundColor Green ' "ADVANCED SCRIPT CONFIGURATION: Registry Switches" ' -n; Write-Host 'section.'
	Write-Host " "
	Write-Host -ForegroundColor Black -BackgroundColor Red "THIS IS YOUR LAST WARNING!!!" 
	Write-Host -ForegroundColor Cyan "If you are sure and want to proceed, answer `"DELETE`"."
	Write-Host "> " -n ; $deload = Read-Host
	switch ($deload) {
		{$deload -like "delete"} {}
		default {
			Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 3 -Type DWord -Force
			exit
		}
	}
}
function Confirm-Starting {
	Write-Host -ForegroundColor Black -BackgroundColor Yellow "Are sure you want to start?"
	Write-Host -ForegroundColor Yellow "This action is IRREVERSIBLE! If you are ready, answer `"1`" once again."
	Write-Host -ForegroundColor Red "UAC will be disabled immediately once you start the script."
	
	Write-Host "> " -n ; $startfirm = Read-Host
	switch ($startfirm) {
		{$startfirm -like "1"} {}
		default {
			Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 3 -Type DWord -Force
			exit
		}
	}
}
function Reset-Script {
	Write-Host -ForegroundColor Yellow "`r`nDo you want to clean up what the script created (basically resetting it)? (Yes)"

	Write-Host "> " -n ; $resetfirm = Read-Host
	switch ($resetfirm) {
		{$resetfirm -like "yes"} {Remove-Item $datadir -Force -Recurse; Remove-Item HKCU:\Software\AutoIDKU -Recurse; Remove-Item HKCU:\Software\BioniDKU -Recurse; exit}
		default {exit}
	}
}
function Check-Defender {
	$notdctrled = Get-Process MsMpEng
	if ($notdctrled) {
		return $false
	} else {return $true}
}
function Check-EnoughActions {
	switch ($true) {
		{$essentialapps -eq 1} {}
		$removeUWPapps {}
		$registrytweaks {}
		$removesystemapps {}
		default {
			return $false
		}
	}
}

$confulee = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ConfigEditing
$confuone = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ChangesMade
$ds       = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").DarkSakura
if ($confulee -eq 2) {$confules = 2} elseif ($confulee -eq 3) {$confules = 3}
else {
	$snareason1 = " - You did not select enough options in Advanced script configuration to proceed.`r`n   Try select a few more options, and try again."
	$snareason2 = " - Windows Defender is currently active. Please disable it (using dControl) and try again."
	switch ($false) {
		# This part needs a better logic rework
		{(Check-EnoughActions) -eq $_} {$snarscode = 1; $startallowed = $false}
		{(Check-Defender) -eq $_} {$snarscode = 2; $startallowed = $false}
		{(Check-Defender) -eq $_ -and (Check-EnoughActions) -eq $_} {$snarscode = 3; $startallowed = $false}
		default {$startallowed = $true}
	}
	Show-Branding clear
	Show-WelcomeText
	switch ($startallowed) {
		{$_ -eq $false} {
			$stcolor = "DarkGray" 
			Write-Host " "
			Write-Host "DENIED:" -ForegroundColor Black -BackgroundColor Red -n; Write-Host -ForegroundColor Red " Starting the script is currently not allowed due to the following reasons:"
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
	$increasewait = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").RunningThisRemotely
	if ($increasewait -eq 1) {
		Write-Host " "
		Write-Host "NOTE: " -ForegroundColor Black -BackgroundColor Yellow; Write-Host ' - Increase wait time is enabled. The script will wait 30 seconds on every system restart before continuing or until you press CTRL+C. You can toggle this option by selecting action 2.' -ForegroundColor White
	}
	Write-Host " "
	Write-Host -ForegroundColor Yellow "What do you want to do?"
	Write-Host -ForegroundColor $stcolor "1. Start the script"
	Write-Host -ForegroundColor White "2. Configure the script"
	Write-Host -ForegroundColor White "3. Further adjust the script (advanced)"
	Write-Host -ForegroundColor White "4. Show credits"
	Write-Host "Answer anything else to exit."
	Write-Host " "
	Write-Host "> " -n ; $confules = Read-Host
}

switch ($confules) {
	{$_ -like "1"} {
		Write-Host " "
		if ($startallowed -eq $false) {
			Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 3 -Type DWord -Force
			exit
		}
		$dlhasfiles = Test-Path -Path "$env:USERPROFILE\Downloads\*"
		if ($removedownloads -and $dlhasfiles) {
			Confirm-DeleteDownloads
			Write-Host " "
		}
		Confirm-Starting
		Write-Host " "
		Start-Process "$datadir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainAccepted${ds}.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
		Write-Host -ForegroundColor Black -BackgroundColor Green "Alright, starting the script..."
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 1 -Type DWord -Force
		Start-Sleep -Seconds 5
		& $coredir\support\getready.ps1
	}
	{$_ -like "2"} {
		$confuleb = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).ConfigEditingSub
		if ($confuleb -eq 7) {& $coredir\support\appspicker.ps1; exit}
		if ($confuleb -eq 5) {& $coredir\music\musicpicker.ps1; exit}
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 3 -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditing" -Value 2 -Type DWord -Force
		Show-Branding clear
		Show-WelcomeText
		$setwallpaper = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SetWallpaper
		$setupmusic = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic
		$increasewait = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").RunningThisRemotely
		$essentialapps = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").EssentialApps
		$windowsupdatesw = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").WUmodeSwitch
		$media10074 = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Media10074
		if ($build -eq 10240 -and $disablelogonbg) {$wucolor = "DarkGray"} else {$wucolor = "White"}
		Write-Host " "
		Write-Host -ForegroundColor Yellow "Configure the script by tuning the following options to your desire."
		Write-Host -ForegroundColor $wucolor "1. Toggle Windows Update mode" -n; if ($build -eq 10240 -and $disablelogonbg) {Write-Host " (FORCEFULLY ENABLED)" -ForegroundColor DarkGray} else {Show-Disenabled $windowsupdatesw}
		Write-Host -ForegroundColor White "2. Set desktop wallpaper to the one from the script" -n; Show-Disenabled $setwallpaper
		Write-Host -ForegroundColor White "3. Use sounds from Windows 10 build 10074 instead of Windows 8" -n; Show-Disenabled $media10074
		Write-Host -ForegroundColor White "4. Increase wait time (ideal for remote setups)" -n; Show-Disenabled $increasewait
		Write-Host -ForegroundColor White "5. Toggle background music" -n; Show-Disenabled $setupmusic
		if ($setupmusic -eq 1) {Write-Host -ForegroundColor White "6. Customize your music selection"}
		Write-Host -ForegroundColor White "7. Toggle the installation of Essential Apps" -n; Show-Disenabled $essentialapps
		if ($essentialapps -eq 1) {Write-Host -ForegroundColor White "8. Customize which Apps to install"}
		Write-Host -ForegroundColor White "0. Accept the current configuration and return to main menu"
		Write-Host " "
		Write-Host "> " -n ; $confulee = Read-Host
		switch ($confulee) {
			{$_ -like "1"} {if ($build -eq 10240 -and $disablelogonbg) {exit} else {Select-Disenabled WUmodeSwitch; exit}}
			{$_ -like "2"} {Select-Disenabled SetWallpaper; exit}
			{$_ -like "3"} {Select-Disenabled Media10074; exit}
			{$_ -like "4"} {Select-Disenabled RunningThisRemotely; exit}
			{$_ -like "5"} {Select-Disenabled HikaruMusic; exit}
			{$_ -like "6"} {if ($setupmusic -eq 1) {& $coredir\music\musicpicker.ps1}; exit}
			{$_ -like "7"} {Select-Disenabled EssentialApps; exit}
			{$_ -like "8"} {if ($essentialapps -eq 1) {& $coredir\support\appspicker.ps1}; exit}
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
		Write-Host "> " -n ; $confulee = Read-Host
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
		Reset-Script
	}
}
