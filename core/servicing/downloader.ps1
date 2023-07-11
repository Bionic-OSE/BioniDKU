# BioniDKU software downloader - (c) Bionic Butter
# The purpose is to save bandwidth, and later to allow you to have the main stage running completely offline without any problems

function Start-DownloadLoop($link,$destfile,$name) {
	while ($true) {
		Start-BitsTransfer -DisplayName "Downloading $name" -Description " " -Source $link -Destination $workdir\dls\$destfile -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		if (Test-Path -Path "$workdir\dls\$destfile" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor Black -BackgroundColor Red "Ehhhhhhh"
			Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
		}
	}
}

$WinaeroTweaker = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").WinaeroTweaker
$OpenShell      = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").OpenShell
$TClock         = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").TClock
$Firefox        = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").Firefox
$NPP            = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").NPP
$ShareX         = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").ShareX
$PDN            = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").PDN
$PENM           = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").PENM
$ClassicTM      = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").ClassicTM
$DesktopInfo    = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").DesktopInfo
$essentialnone  = $false
function Write-AppsList($action) {
	Write-Host -ForegroundColor Cyan "The following programs will be $action"
	switch (1) {
		$WinaeroTweaker {Write-Host -ForegroundColor Cyan "- Winaero Tweaker"} #dl1
		$OpenShell      {Write-Host -ForegroundColor Cyan "- Open-Shell" -n; Write-Host " (4.4.170)"} #dl2
		$TClock         {Write-Host -ForegroundColor Cyan "- T-Clock" -n; Write-Host " (2.4.4)"} #dl4
		$Firefox        {if ($action -like "downloaded:") {Write-Host -ForegroundColor Cyan "- Mozilla Firefox ESR"}} #dl6
		$NPP            {Write-Host -ForegroundColor Cyan "- Notepad++" -n; Write-Host " (8.5)"} #dl8
		$ShareX         {Write-Host -ForegroundColor Cyan "- ShareX" -n; Write-Host " (13.1.0)"} #dl9
		$PDN            {Write-Host -ForegroundColor Cyan "- Paint.NET" -n; Write-Host " (4.0.19)"} #dl10 but same as dl5
		$PENM           {Write-Host -ForegroundColor Cyan "- PENetwork Manager"} #dl5
		$ClassicTM      {Write-Host -ForegroundColor Cyan "- Classic Task Manager & Classic System Configuration"} #dl11 but same as dl5
		$DesktopInfo    {Write-Host -ForegroundColor Cyan "- DesktopInfo" -n; Write-Host " (2.10.2, with custom configuration)"}
		default {
			Write-Host -ForegroundColor Red "You selected NONE, are you kidding me???"
			$essentialnone = $true
		}
	}
	if ($essentialnone -ne $true) {Write-Host "Some of these might not be on their latest releases. You can update them on your own later."}
}
$hkm = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).HikaruMode
if ($hkm -eq 0) {
	Write-Host "Installing essential programs" -ForegroundColor Cyan -BackgroundColor DarkGray
	Write-AppsList "installed:"
	exit
}

$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Download mode - DO NOT CLOSE THIS WINDOW OR DISCONNECT INTERNET"
function Stop-DownloadMode($nhkm) {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 1 -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value $nhkm -Type DWord -Force
	Stop-Process -Name "FFPlay" -Force -ErrorAction SilentlyContinue
	Stop-Process -Name "SndVol" -Force -ErrorAction SilentlyContinue
	exit
}
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Download mode" -ForegroundColor Blue -BackgroundColor Gray
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
$hkau = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic
if ($hkau -eq 1) {
	$n = Get-Random -Minimum 1 -Maximum 4
	Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $coredir\ambient\ChillWait$n.mp3 -nodisp -loglevel quiet -loop 0 -hide_banner"
	Start-Process "$env:SYSTEMDRIVE\Windows\SysWOW64\SndVol.exe"
	Write-Host -ForegroundColor White "For more information on the currently playing music, refer to $coredir\ambient\ChillWaitInfo.txt"
	Write-Host -ForegroundColor Yellow "DO NOT adjust the volume of FFPlay! It will affect your music experience later on!"
}
Start-Sleep -Seconds 3

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Getting Utilities package"
Start-Process powershell -Wait -ArgumentList "-Command $workdir\utils\utilsg.ps1" -WorkingDirectory $workdir\utils
if ((Test-Path -Path "$env:SYSTEMDRIVE\Windows\ContextMenuNormalizer") -eq $false) {New-Item -Path "$env:SYSTEMDRIVE\Windows" -Name "ContextMenuNormalizer" -ItemType directory}
Copy-Item "$workdir\utils\ContextMenuNormalizer.exe" -Destination "$env:SYSTEMDRIVE\Windows\ContextMenuNormalizer"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "ContextMenuNormalizer" -Value "$env:SYSTEMDRIVE\Windows\ContextMenuNormalizer\ContextMenuNormalizer.exe" -Type String -Force

if ($hkau -eq 1) {
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Getting music packages"
	Start-Process powershell -Wait -ArgumentList "-Command $workdir\music\musicn.ps1" -WorkingDirectory $workdir\music
}

$esapps = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).EssentialApps
if ($esapps -eq 1) {
	Write-Host " "
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Downloading essential programs"
	Write-AppsList "downloaded:"
	if ($essentialnone -ne $true) {
		Import-Module BitsTransfer
		# Download links
		$dl1 = "https://winaerotweaker.com/download/winaerotweaker.zip"
		$dl2 = "https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.170/OpenShellSetup_4_4_170.exe"
		$dl4 = "https://github.com/White-Tiger/T-Clock/releases/download/v2.4.4%23492-rc/T-Clock.zip"
		$dl6 = "https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=en-US"
		$dl8 = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5/npp.8.5.Installer.x64.exe"
		$dl9 = "https://github.com/ShareX/ShareX/releases/download/v13.1.0/ShareX-13.1.0-setup.exe"
		# Download'em all
		switch (1) {
			$WinaeroTweaker {Start-DownloadLoop $dl1 winaero.zip "Winaero Tweaker"}
			$OpenShell {Start-DownloadLoop $dl2 openshellinstaller.exe "Open-Shell"}
			$TClock {Start-DownloadLoop $dl4 tclock.zip "TClock"}
			$Firefox {Start-DownloadLoop $dl6 firefoxesr.exe "Firefox ESR"}
			$NPP {Start-DownloadLoop $dl8 npp.exe "Notepad++"}
			$ShareX {Start-DownloadLoop $dl9 sharex462.exe "ShareX"}
		}
	}
}

$pwsh = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Pwsh
$dotnet462d = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").NET462
if ($pwsh -eq 5 -and $dotnet462d -eq 1) {
	Write-Host " "
	Write-Host "Downloading .NET 4.6.2" -ForegroundColor Cyan -BackgroundColor DarkGray
	Write-Host "If it fails to download, please manually download via this link:"  -BackgroundColor Cyan -ForegroundColor Black 
	Write-Host "https://go.microsoft.com/fwlink/?LinkId=780600" -ForegroundColor Cyan
	$462dl = "https://download.visualstudio.microsoft.com/download/pr/8e396c75-4d0d-41d3-aea8-848babc2736a/80b431456d8866ebe053eb8b81a168b3/ndp462-kb3151800-x86-x64-allos-enu.exe"
	Start-BitsTransfer -DisplayName "Downloading .NET 4.6.2" -Description " " -Source $462dl -Destination $workdir\dls\dotnet462.exe
	Stop-DownloadMode 1
} elseif ($pwsh -eq 5) {Stop-DownloadMode 1}

$wu = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).WUmode
$ngawarn = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).SkipNotGABWarn
if ($wu -eq 1 -and $ngawarn -ne 1) {
	Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU/raw/main/PATCHME.ps1" "PATCHME.ps1" "UBR information file"
	Write-Host " "
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Downloading and installing PSWindowsUpdate"
	Install-PackageProvider -Name "NuGet" -Verbose -Force
	Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
	Add-Type -AssemblyName presentationCore
	Install-Module PSWindowsUpdate -Verbose
	Stop-DownloadMode 2
}

Stop-DownloadMode 1
