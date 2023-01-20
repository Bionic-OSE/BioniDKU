Write-Host "Installing required programs" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
Write-Host -ForegroundColor Cyan "The following programs will be installed:"
Write-Host -ForegroundColor Cyan "- Winaero Tweaker"
Write-Host -ForegroundColor Cyan "- OpenShell"
Write-Host -ForegroundColor Cyan "- AutoHotKey"
Write-Host -ForegroundColor Cyan "- T-Clock"
Write-Host -ForegroundColor Cyan "- PENetwork Manager" -n; Write-Host " (Hi Julia)"

$dl1 = "https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.170/OpenShellSetup_4_4_170.exe"
$dl2 = "https://winaerotweaker.com/download/winaerotweaker.zip"
$dl3 = "https://github.com/Lexikos/AutoHotkey_L/releases/download/v1.1.33.10/AutoHotkey_1.1.33.10_setup.exe"
$dl4 = "https://github.com/White-Tiger/T-Clock/releases/download/v2.4.4%23492-rc/T-Clock.zip"

Start-BitsTransfer -Source $dl1 -Destination $workdir\openshellinstaller.exe -RetryInterval 60
Start-BitsTransfer -Source $dl2 -Destination $workdir\winaero.zip -RetryInterval 60
Start-BitsTransfer -Source $dl3 -Destination $workdir\ahksetup.exe -RetryInterval 60
Start-BitsTransfer -Source $dl4 -Destination $workdir\tclock.zip -RetryInterval 60

New-Item -Path $env:USERPROFILE -Name "tclock" -ItemType Directory
Expand-Archive -Path $workdir\winaero.zip -DestinationPath $workdir 
Expand-Archive -Path $workdir\tclock.zip -DestinationPath $env:USERPROFILE\tclock
Expand-Archive -Path $workdir\utils\penm.zip -DestinationPath "C:\Windows\PENetwork"
Copy-Item -Path $workdir\utils\PENetwork.lnk -Destination "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\PENetwork.lnk"

Start-Process $workdir\openshellinstaller.exe -Wait -NoNewWindow -ArgumentList "/qn ADDLOCAL=StartMenu"
Start-Process "$workdir\WinaeroTweaker-1.40.0.0-setup.exe" -Wait -NoNewWindow -ArgumentList "/SP- /VERYSILENT"
Start-Process $workdir\ahksetup.exe -Wait -NoNewWindow -ArgumentList "/S"
reg.exe import $workdir\utils\PENM.reg
Start-Process C:\Windows\PENetwork\PENetwork.exe -NoNewWindow
reg.exe import $workdir\utils\tclock.reg
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$tclock = "$env:USERPROFILE\tclock\Clock64.exe"
$ShortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\tclock.lnk"
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $tclock
$shortcut.WindowStyle = 1
$shortcut.Save()