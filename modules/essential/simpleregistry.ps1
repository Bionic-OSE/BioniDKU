switch ($true) {
	
	$applookupinstore {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling App Lookup in Microsoft Store"
		$ifexist = (Test-Path -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer')
		if ($ifexist -eq $false) {New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name "Explorer" -ItemType Directory}
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name "NoUseStoreOpenWith" -Value 1 -Type DWord -Force
	}

	{$showsuperhidden} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Unhiding hidden system files and folders"
		Write-Host -ForegroundColor White "For these to show, you must first show normal hidden files and folders"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSuperHidden' -Value 1 -Type DWord -Force
	}

	{$removequickaccess -and $explorerstartfldr} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing Quick Access"
		if ($pwsh -eq 7) {
			Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'HubMode' -Value 1 -Type DWord -Force
		} else {
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Classes\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder" -Name 'Attributes' -Value 0xA0600000 -Type DWord -Force
		}
	}

	{$disabledefenderstart -eq $true -and $build -ge 14393} {
		Write-Host  -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Windows Defender on startup"
		Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run' -Name 'SecurityHealth' -Value ([byte[]](0x33,0x32,0xFF))
	}
	
	$disablenotifs {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Toast Notifications" 
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'ToastEnabled' -Value 0 -Type DWord -Force
	}
	
	{$disablegamebar -and $build -ge 15063} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Game Bar"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -Value 0 -Type DWord -Force
	}
	
	$disableautoplay {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling AutoPlay"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoDriveTypeAutoRun' -Value 255 -Type DWord -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' -Name 'DisableAutoplay' -Value 1 -Type DWord -Force
	}
	
	$disablemultitaskbar {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Multi-monitor taskbar"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'MMTaskbarEnabled' -Value 0 -Type DWord -Force
	}
	
	$disabletransparency {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Transparency"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -Value 0 -Type DWord -Force
	}
	
	{$disablewinink -and $build -ge 14393} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Windows Ink Workspace"
		New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name 'WindowsInkWorkspace' -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace' -Name 'AllowWindowsInkWorkspace' -Value 0 -Type DWord -Force
	}
	
	$removedownloads {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing Downloads Folder"
		$dlhasfiles = Test-Path -Path "$env:USERPROFILE\Downloads\*"
		if ($dlhasfiles -eq $true) {
			Write-Host "DELETING YOUR DOWNLOADS FOLDER as you specified." -ForegroundColor Red -BackgroundColor DarkGray
			Import-Module -Name $PSScriptRoot\..\lib\Remove-ItemWithProgress.psm1
			Remove-ItemWithProgress -Path "$env:USERPROFILE\Downloads"
		} else {
			Remove-Item -Path "$env:USERPROFILE\Downloads" -Force -Recurse
		}
		Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}' -Force
		Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}' -Force 
		Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}' -Force
		Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}' -Force
	}
	
	{$classicpaint -and $build -ge 15063} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Enabling Classic Paint"
		New-item -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Applets\Paint' -Name "Settings"
		Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Applets\Paint' -Name "DisableModernPaintBootstrap" -Value 1 -Type DWord -Force
	}
	
	$contextmenuentries {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Tuning the Context Menu"
		New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
		$modernsharexists = Test-Path -LiteralPath "HKCR:\*\ShellEx\ContextMenuHandlers\ModernSharing"
		$idkwhattocallthis = Test-Path -Path "HKCR:\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}"
		switch ($true) {
			$modernsharexists {Remove-Item -LiteralPath "HKCR:\*\ShellEx\ContextMenuHandlers\ModernSharing" -Force -Recurse}
			$idkwhattocallthis {Remove-Item -Path "HKCR:\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" -Force -Recurse}
		}
	}
	
	$disableanimations {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Window Animations"
		Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Type String -Value '0'
	}
	
	{$remove3Dobjects -and $build -ge 16299} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing 3D Objects from This PC"
		Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}' -Force
	}
	
	$defaultcolor {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting the Accent color to Default Blue"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'AccentColor' -Value 4292311040 -Type DWord -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'ColorizationAfterglow' -Value 3288365271 -Type DWord -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'ColorizationColor' -Value 3288365271 -Type DWord -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'ColorPrevalence' -Value 0 -Type DWord -Force
	}
	
	$hidebluetoothicon {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Hiding Bluetooth Icon"
		Set-ItemProperty -Path 'HKCU:\Control Panel\Bluetooth' -Name 'Notification Area Icon' -Value 0 -Type DWord -Force
	}
	
	$activatephotoviewer {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Activating Windows Photo Viewer"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".bmp" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".dib" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".gif" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jfif" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jpe" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jpeg" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jpg" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jxr" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".png" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".tif" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".tiff" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
	}
	
	$registeredowner {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting Registered owner"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'RegisteredOwner' -Value 'Project BioniDKU - (c) Bionic Butter' -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'RegisteredOrganization' -Value "$butter" -Type String -Force
	}
	
	$disableedgeprelaunch {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Edge Prelaunch"
		New-Item -Path 'HKCU:\SOFTWARE\Policies\Microsoft' -Name 'MicrosoftEdge' -Force
		New-Item -Path 'HKCU:\SOFTWARE\Policies\Microsoft\MicrosoftEdge' -Name 'Main' -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\MicrosoftEdge' -Name 'AllowPrelaunch' -Value 0 -Type DWord -Force
	}
	
	$disablecortana {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Cortana"
		New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Windows Search'
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -Value 0 -Type DWord -Force
	}
	
	$disablestoreautoupd {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Microsoft Store Automatic App Updates"
		New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name 'WindowsStore'
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore' -Name 'AutoDownload' -Value 2 -Type DWord -Force
	}
	
	$oldvolcontrol {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Enabling old volume control"
		New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'MTCUVC'
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC' -Name 'EnableMtcUvc' -Value 0 -Type DWord -Force
	}
	
	$balloonnotifs {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Enabling Balloon notificatons"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'EnableLegacyBalloonNotifications' -Value 1 -Type DWord -Force
	}
	
	$showalltrayicons {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Showing all tray icons in the taskbar"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'EnableAutoTray' -Value 0 -Type DWord -Force
	}
	
	$disablelockscrn {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling LogonUI's Clock screen (aka the Lock Screen)"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData' -Name 'AllowLockScreen' -Value 0 -Type DWord -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name DisableWindowsSpotlightFeatures -Value 1 -Type DWord -Force
	}
	
	$classicalttab {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Enabling Classic Alt+Tab"
		Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'AltTabSettings' -Value 1 -Type DWord -Force
	}
	
	$disablelocationicon {
		$located = Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location'
		if ($located) {
			Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling the Location icon"
			Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -Name Value -Value "Deny" -Type String -Force
		}
	}
	
	$disablelogonbg {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling LogonUI's background image"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name "DisableLogonBackgroundImage" -Value 1 -Type DWord -Force
	}
	
	$removelckscrneticon {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing the network icon from LogonUI"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name "DontDisplayNetworkSelectionUI" -Value 1 -Type DWord -Force
	}
	
	$svchostslimming {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting svchost.exe to max RAM"
		$svchostvalue = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1kb
		Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name "SvcHostSplitThresholdInKB" -Value $svchostvalue -Type DWord -Force
	}
	
}
