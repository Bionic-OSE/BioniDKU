function Write-AppsList($action) {
	Write-Host -ForegroundColor Cyan "The following programs will be $action"
	Write-Host -ForegroundColor Cyan "- Winaero Tweaker" #dl1
	Write-Host -ForegroundColor Cyan "- Open-Shell" -n; Write-Host " (4.4.170)" #dl2
	Write-Host -ForegroundColor Cyan "- T-Clock" -n; Write-Host " (2.4.4)" #dl4
	Write-Host -ForegroundColor Cyan "- PENetwork Manager" -n; Write-Host " (Hi Julia)" #dl5 but built-in, so no dl
	Write-Host -ForegroundColor Cyan "- Mozilla Firefox ESR" #dl6
	Write-Host -ForegroundColor Cyan "- Notepad++" -n; Write-Host " (8.5, Hi Zach)" #dl8
	Write-Host -ForegroundColor Cyan "- ShareX (13.1.0)" #dl9
	Write-Host -ForegroundColor Cyan "- Paint.NET (4.0.19)" #dl10 but same as dl5
	Write-Host -ForegroundColor Cyan "- Classic Task Manager & Classic System Configuration" #dl11 but same as dl5
	Write-Host -ForegroundColor Cyan "- DesktopInfo (2.10.2, with custom configuration)"
	Write-Host "Some of these might not be on their latest releases. You can update them on your own later."
}
$hkm = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).HikaruMode
if ($hkm -eq 0) {
	Write-Host "Installing essential programs" -ForegroundColor Cyan -BackgroundColor DarkGray
	Write-AppsList "installed:"
	exit
}

$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Download mode - DO NOT CLOSE THIS WINDOW"
function Stop-DownloadMode($nhkm) {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 1 -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value $nhkm -Type DWord -Force
	Stop-Process -Name "FFPlay" -Force -ErrorAction SilentlyContinue
	exit
}
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "Download mode" -ForegroundColor Blue -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
Show-Branding
$workdir = Split-Path(Split-Path "$PSScriptRoot")
$coredir = Split-Path "$PSScriptRoot"
# Create downloads folder
$dlfe = Test-Path -Path "$workdir\dls"
if ($dlfe -eq $false) {
	New-Item -Path $workdir -Name dls -itemType Directory | Out-Null
}
Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $coredir\ambient\MidnightWait.mp3 -nodisp -loglevel quiet -loop 0 -hide_banner"

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Getting Utilities package"
Start-Process powershell -Wait -ArgumentList "-Command $workdir\utils\utilsg.ps1" -WorkingDirectory $workdir\utils

$hkau = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic
if ($hkau -eq 1) {
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Getting music packages"
	Start-Process powershell -Wait -ArgumentList "-Command $workdir\music\musicn.ps1" -WorkingDirectory $workdir\music
}

# To-do for this part: Make a registry system for switching each app on and off
$esapps = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).EssentialApps
if ($esapps -eq 1) {
	Write-Host " "
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Downloading essential programs"
	Write-AppsList "downloaded:"
	Import-Module BitsTransfer
	# Download links
	$dl1 = "https://winaerotweaker.com/download/winaerotweaker.zip"
	$dl2 = "https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.170/OpenShellSetup_4_4_170.exe"
	$dl4 = "https://github.com/White-Tiger/T-Clock/releases/download/v2.4.4%23492-rc/T-Clock.zip"
	$dl6 = "https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=en-US"
	$dl8 = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5/npp.8.5.Installer.x64.exe"
	$dl9 = "https://github.com/ShareX/ShareX/releases/download/v13.1.0/ShareX-13.1.0-setup.exe"
	# Download'em all
	Start-BitsTransfer -Source $dl1 -Destination $workdir\dls\winaero.zip -RetryInterval 60
	Start-BitsTransfer -Source $dl2 -Destination $workdir\dls\openshellinstaller.exe -RetryInterval 60
	Start-BitsTransfer -Source $dl4 -Destination $workdir\dls\tclock.zip -RetryInterval 60
	Start-BitsTransfer -Source $dl6 -Destination $workdir\dls\firefoxesr.exe -RetryInterval 60
	Start-BitsTransfer -Source $dl8 -Destination $workdir\dls\npp.exe -RetryInterval 60
	Start-BitsTransfer -Source $dl9 -Destination $workdir\dls\sharex462.exe -RetryInterval 60
}

$pwsh = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Pwsh
if ($pwsh -eq 5) {
	Write-Host " "
	Write-Host "Downloading .NET 4.6.2" -ForegroundColor Cyan -BackgroundColor DarkGray
	Write-Host "If it fails to download, please manually download via this link:"  -BackgroundColor Cyan -ForegroundColor Black 
	Write-Host "https://go.microsoft.com/fwlink/?LinkId=780600" -ForegroundColor Cyan
	$462dl = "https://download.visualstudio.microsoft.com/download/pr/8e396c75-4d0d-41d3-aea8-848babc2736a/80b431456d8866ebe053eb8b81a168b3/ndp462-kb3151800-x86-x64-allos-enu.exe"
	Start-BitsTransfer -Source $462dl -Destination $workdir\dls\dotnet462.exe
	Stop-DownloadMode 1
}

$wu = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).WUmode
if ($wu -eq 1) {
	Write-Host " "
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Downloading and installing PSWindowsUpdate"
	Install-PackageProvider -Name "NuGet" -Verbose -Force
	Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
	Add-Type -AssemblyName presentationCore
	Install-Module PSWindowsUpdate -Verbose
	Stop-DownloadMode 2
}

Stop-DownloadMode 1
