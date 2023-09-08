Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing Essential Apps"
. $coredir\servicing\downloader.ps1
if ($essentialnone) {exit}
$ds = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").DarkSakura

switch (1) {
	$WinaeroTweaker {
		Expand-Archive -Path $workdir\dls\winaero.zip -DestinationPath $workdir\dls
		$waxe = (Get-ChildItem -Path $workdir\dls -Filter WinaeroTweaker*.exe)
		Start-Process "$workdir\dls\$waxe" -Wait -NoNewWindow -ArgumentList "/SP- /VERYSILENT"
	}
	$OpenShell {
		Start-Process $workdir\dls\openshellinstaller.exe -Wait -NoNewWindow -ArgumentList "/qn ADDLOCAL=StartMenu"
		if ($openshellconfig) {
			Expand-Archive -Path $workdir\utils\Fluent.zip -DestinationPath "$env:PROGRAMFILES\Open-Shell\Skins"
			Start-Process "$env:PROGRAMFILES\Open-Shell\StartMenu.exe" -NoNewWindow -ArgumentList "-xml $workdir\utils\menu${ds}.xml"
		}
	}
	$TClock {
		New-Item -Path $env:USERPROFILE -Name "tclock" -ItemType Directory | Out-Null
		Expand-Archive -Path $workdir\dls\tclock.zip -DestinationPath $env:USERPROFILE\tclock
		reg.exe import $workdir\utils\tclock.reg
		$WScriptObj = New-Object -ComObject ("WScript.Shell")
		$tclock = "$env:USERPROFILE\tclock\Clock64.exe"
		$ShortcutPath1 = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\tclock.lnk"
		$shortcut1 = $WscriptObj.CreateShortcut($ShortcutPath1)
		$shortcut1.TargetPath = $tclock
		$shortcut1.WindowStyle = 1
		$shortcut1.Save()
	}
	$NPP {
		Start-Process $workdir\dls\npp.exe -Wait -NoNewWindow -ArgumentList "/S"
	}
	$VLC {
		Start-Process $workdir\dls\vlc.exe -Wait -NoNewWindow -ArgumentList "/S"
	}
	$PENM {
		Expand-Archive -Path $workdir\utils\penm.zip -DestinationPath "$env:SYSTEMDRIVE\Windows\PENetwork"
		Copy-Item -Path $env:SYSTEMDRIVE\Windows\PENetwork\PENetwork.lnk -Destination "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\PENetwork.lnk"
		reg.exe import $workdir\utils\PENM.reg
		Start-Process C:\Windows\PENetwork\PENetwork.exe
	}
	$ShareX {
		Start-Process $workdir\dls\sharex462.exe -Wait -NoNewWindow -ArgumentList "/VERYSILENT /NORUN"
		$sxnou = Test-Path -Path "$env:USERPROFILE\Documents\ShareX"
		if ($sxnou -eq $false) {
			New-Item -Path "$env:USERPROFILE\Documents" -Name ShareX -itemType Directory
		}
		Copy-Item -Path $workdir\utils\ApplicationConfig.json -Destination "$env:USERPROFILE\Documents\ShareX\ApplicationConfig.json"
	}
	$ClassicTM {
		Expand-Archive -Path $workdir\utils\tm_cfg_win8-win10.zip -DestinationPath $workdir\dls
		Start-Process $workdir\dls\tm_cfg_win8-win10.exe -NoNewWindow -Wait -ArgumentList "/SILENT"
	}
	$DesktopInfo {
		$deskinfo = "$env:SYSTEMDRIVE\Program Files\DesktopInfo"
		Expand-Archive -Path $workdir\utils\DesktopInfo.zip -DestinationPath $deskinfo
		$ShortcutPath2 = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\DesktopInfo.lnk"
		$shortcut2 = $WscriptObj.CreateShortcut($ShortcutPath2)
		$shortcut2.TargetPath = "$deskinfo\DesktopInfo.exe"
		$shortcut2.Save()
		Copy-Item -Force -Path $deskinfo\Convection\Conv.ttf -Destination C:\Windows\Fonts\Conv.ttf
		Copy-Item -Force -Path $deskinfo\Convection\Convb.ttf -Destination C:\Windows\Fonts\Convb.ttf
		Copy-Item -Force -Path $deskinfo\Convection\Convc.ttf -Destination C:\Windows\Fonts\Convc.ttf
		Copy-Item -Force -Path $deskinfo\Convection\Convexb.ttf -Destination C:\Windows\Fonts\Convexb.ttf
		Copy-Item -Force -Path $deskinfo\Convection\Convit.ttf -Destination C:\Windows\Fonts\Convit.ttf
		Copy-Item -Force -Path $deskinfo\Convection\Convmd.ttf -Destination C:\Windows\Fonts\Convmd.ttf
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Convection (TrueType)" -Value "Conv.ttf" -Type String -Force
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Convection Bold (TrueType)" -Value "Convb.ttf" -Type String -Force
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Convection Condensed (TrueType)" -Value "Convc.ttf" -Type String -Force
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Convection Extra Bold (TrueType)" -Value "Convexb.ttf" -Type String -Force
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Convection Italic (TrueType)" -Value "Convit.ttf" -Type String -Force
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Convection Medium (TrueType)" -Value "Convmd.ttf" -Type String -Force
	}
	$PDN {
		Start-Process $workdir\utils\paintdotnet462.exe -NoNewWindow -Wait -ArgumentList "/AUTO"
	}
}
