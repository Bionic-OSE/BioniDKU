Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing Essential Apps"
. $coredir\servicing\downloader.ps1
if ($essentialnone) {exit}

switch (1) {
	$WinaeroTweaker {
		Expand-Archive -Path $datadir\dls\winaero.zip -DestinationPath $datadir\dls
		$waxe = (Get-ChildItem -Path $datadir\dls -Filter WinaeroTweaker*.exe)
		Start-Process "$datadir\dls\$waxe" -Wait -NoNewWindow -ArgumentList "/SP- /VERYSILENT"
	}
	$OpenShell {
		Start-Process $datadir\dls\openshellinstaller.exe -Wait -NoNewWindow -ArgumentList "/qn ADDLOCAL=StartMenu"
		if ($openshellconfig) {
			Expand-Archive -Path $datadir\utils\Fluent.zip -DestinationPath "$env:PROGRAMFILES\Open-Shell\Skins"
			Start-Process "$env:PROGRAMFILES\Open-Shell\StartMenu.exe" -NoNewWindow -ArgumentList "-xml $datadir\utils\menu.xml"
		}
	}
	$TClock {
		New-Item -Path $env:USERPROFILE -Name "tclock" -ItemType Directory | Out-Null
		Expand-Archive -Path $datadir\dls\tclock.zip -DestinationPath $env:USERPROFILE\tclock
		reg.exe import $datadir\utils\tclock.reg
		$WScriptObj = New-Object -ComObject ("WScript.Shell")
		$tclock = "$env:USERPROFILE\tclock\Clock64.exe"
		$ShortcutPath1 = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\tclock.lnk"
		$shortcut1 = $WscriptObj.CreateShortcut($ShortcutPath1)
		$shortcut1.TargetPath = $tclock
		$shortcut1.WindowStyle = 1
		$shortcut1.Save()
	}
	$NPP {
		Start-Process $datadir\dls\npp.exe -Wait -NoNewWindow -ArgumentList "/S"
	}
	$VLC {
		$vlce = (Get-ChildItem -Path $datadir\dls -Filter vlc*.exe)
		Start-Process "$datadir\dls\$vlce" -Wait -ArgumentList "/S"
	}
	$PENM {
		Expand-Archive -Path $datadir\utils\penm.zip -DestinationPath "$env:SYSTEMDRIVE\Windows\PENetwork"
		Copy-Item -Path $env:SYSTEMDRIVE\Windows\PENetwork\PENetwork.lnk -Destination "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\PENetwork.lnk"
		reg.exe import $datadir\utils\PENM.reg
		Start-Process $env:SYSTEMDRIVE\Windows\PENetwork\PENetwork.exe
	}
	$ShareX {
		Start-Process $datadir\dls\sharex462.exe -Wait -NoNewWindow -ArgumentList "/VERYSILENT /NORUN"
		$sxnou = Test-Path -Path "$env:USERPROFILE\Documents\ShareX"
		if ($sxnou -eq $false) {
			New-Item -Path "$env:USERPROFILE\Documents" -Name ShareX -itemType Directory
		}
		Copy-Item -Path $datadir\utils\ApplicationConfig.json -Destination "$env:USERPROFILE\Documents\ShareX\ApplicationConfig.json"
	}
	$ClassicTM {
		Expand-Archive -Path $datadir\utils\tm_cfg_win8-win10.zip -DestinationPath $datadir\dls
		Start-Process $datadir\dls\tm_cfg_win8-win10.exe -NoNewWindow -Wait -ArgumentList "/SILENT"
	}
	$DesktopInfo {
		$deskinfo = "$env:SYSTEMDRIVE\Program Files\DesktopInfo"
		Expand-Archive -Path $datadir\utils\DesktopInfo.zip -DestinationPath $deskinfo
		$ShortcutPath2 = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\DesktopInfo.lnk"
		$shortcut2 = $WscriptObj.CreateShortcut($ShortcutPath2)
		$shortcut2.TargetPath = "$deskinfo\DesktopInfo.exe"
		$shortcut2.Save()
		Copy-Item -Force -Path $deskinfo\Convection\Conv.ttf -Destination $env:SYSTEMDRIVE\Windows\Fonts\Conv.ttf
		Copy-Item -Force -Path $deskinfo\Convection\Convb.ttf -Destination $env:SYSTEMDRIVE\Windows\Fonts\Convb.ttf
		Copy-Item -Force -Path $deskinfo\Convection\Convc.ttf -Destination $env:SYSTEMDRIVE\Windows\Fonts\Convc.ttf
		Copy-Item -Force -Path $deskinfo\Convection\Convexb.ttf -Destination $env:SYSTEMDRIVE\Windows\Fonts\Convexb.ttf
		Copy-Item -Force -Path $deskinfo\Convection\Convit.ttf -Destination $env:SYSTEMDRIVE\Windows\Fonts\Convit.ttf
		Copy-Item -Force -Path $deskinfo\Convection\Convmd.ttf -Destination $env:SYSTEMDRIVE\Windows\Fonts\Convmd.ttf
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Convection (TrueType)" -Value "Conv.ttf" -Type String -Force
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Convection Bold (TrueType)" -Value "Convb.ttf" -Type String -Force
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Convection Condensed (TrueType)" -Value "Convc.ttf" -Type String -Force
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Convection Extra Bold (TrueType)" -Value "Convexb.ttf" -Type String -Force
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Convection Italic (TrueType)" -Value "Convit.ttf" -Type String -Force
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Convection Medium (TrueType)" -Value "Convmd.ttf" -Type String -Force
	}
	$PDN {
		Start-Process $datadir\utils\paintdotnet462.exe -NoNewWindow -Wait -ArgumentList "/AUTO"
	}
}
