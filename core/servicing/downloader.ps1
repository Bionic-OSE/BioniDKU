# BioniDKU software downloader - (c) Bionic Butter
# The purpose is to save bandwidth, and later to allow you to have the main stage running completely offline without any problems

function Start-DownloadLoop($link,$destfile,$name) {
	while ($true) {
		Start-BitsTransfer -DisplayName "Downloading $name" -Description " " -Source $link -Destination $datadir\dls\$destfile -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		if (Test-Path -Path "$datadir\dls\$destfile" -PathType Leaf) {break} else {
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
$VLC            = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").VLC
$ds             = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU"     ).DarkSakura
$essentialnone  = $false
function Write-AppsList($action) {
	Write-Host -ForegroundColor Cyan "The following programs will be $action"
	switch (1) {
		$WinaeroTweaker {Write-Host -ForegroundColor Cyan "- Winaero Tweaker"} #dl1
		$OpenShell      {Write-Host -ForegroundColor Cyan "- Open-Shell" -n; Write-Host " ($OShellDispver)"} #dl2
		$TClock         {Write-Host -ForegroundColor Cyan "- T-Clock" -n; Write-Host " (2.4.4)"} #dl4
		$Firefox        {if ($action -like "downloaded:") {Write-Host -ForegroundColor Cyan "- Mozilla Firefox ESR"}} #dl6
		$NPP            {Write-Host -ForegroundColor Cyan "- Notepad++" -n; Write-Host " ($NPPver)"} #dl8
		$ShareX         {Write-Host -ForegroundColor Cyan "- ShareX" -n; Write-Host " (13.1.0)"} #dl9
		$PDN            {Write-Host -ForegroundColor Cyan "- Paint.NET" -n; Write-Host " (4.0.19)"} #dl10 but same as dl5
		$PENM           {Write-Host -ForegroundColor Cyan "- PENetwork Manager"} #dl5
		$ClassicTM      {Write-Host -ForegroundColor Cyan "- Classic Task Manager & Classic System Configuration"} #dl11 but same as dl5
		$DesktopInfo    {Write-Host -ForegroundColor Cyan "- DesktopInfo" -n; Write-Host " (2.10.2, with custom configuration)"}
		$VLC            {Write-Host -ForegroundColor Cyan "- VLC" -n; Write-Host " ($VLCver)"} #dlX, we already have dl10 XD
		default {
			Write-Host -ForegroundColor Red "You selected NONE, are you kidding me???"
			$essentialnone = $true
		}
	}
	if ($essentialnone -ne $true) {Write-Host "Some of these might not be on their latest releases. You can update them on your own later."}
}
$hkm = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).HikaruMode
if ($hkm -eq 0) {
	. $datadir\dls\PATCHME.ps1
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
$global:workdir = Split-Path(Split-Path "$PSScriptRoot")
$global:coredir = Split-Path "$PSScriptRoot"
$global:datadir = "$workdir\data"

$hkau = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic
if ($ds -eq 1) {$min = 4; $max = 7; $avg = "s"} else {$min = 1; $max = 5; $avg = "n"}
if ($hkau -eq 1) {
	$n = Get-Random -Minimum $min -Maximum $max
	Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\ChillWait$n.mp3 -nodisp -loglevel quiet -loop 0 -hide_banner"
	Start-Process "$env:SYSTEMDRIVE\Windows\SysWOW64\SndVol.exe"
	Write-Host -ForegroundColor White "For more information on the currently playing music, refer to $datadir\ambient\ChillWaitInfo.txt"
	Write-Host -ForegroundColor Yellow "DO NOT adjust the volume of FFPlay! It will affect your music experience later on!"
}
Start-Sleep -Seconds 3

Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU/raw/main/PATCHME.ps1" "PATCHME.ps1" "Software versions information file"
. $datadir\dls\PATCHME.ps1

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Getting Utilities package"
Start-Process powershell -Wait -ArgumentList "-Command $coredir\servicing\utilsg.ps1"
if ((Test-Path -Path "$env:SYSTEMDRIVE\Windows\ContextMenuNormalizer") -eq $false) {New-Item -Path "$env:SYSTEMDRIVE\Windows" -Name "ContextMenuNormalizer" -ItemType directory}
if ($build -ge 18362) {
	Copy-Item "$datadir\utils\ContextMenuNormalizer.exe" -Destination "$env:SYSTEMDRIVE\Windows\ContextMenuNormalizer"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "ContextMenuNormalizer" -Value "$env:SYSTEMDRIVE\Windows\ContextMenuNormalizer\ContextMenuNormalizer.exe" -Type String -Force
}

if ($hkau -eq 1) {
	Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-music/raw/music/normal.ps1" "normal.ps1" "Music packages information file"
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Getting music packages"
	Start-Process powershell -Wait -ArgumentList "-Command $coredir\music\music${avg}.ps1"
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
		$dl2 = "https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v${OShellDispver}/OpenShellSetup_${OShellExecver}.exe"
		$dl4 = "https://github.com/White-Tiger/T-Clock/releases/download/v2.4.4%23492-rc/T-Clock.zip"
		$dl6 = "https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=en-US"
		$dl8 = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v${NPPver}/npp.${NPPver}.Installer.x64.exe"
		$dl9 = "https://github.com/ShareX/ShareX/releases/download/v13.1.0/ShareX-13.1.0-setup.exe"
		$dlX = "https://get.videolan.org/vlc/${VLCver}/win64/vlc-${VLCver}-win64.exe"
		# Download'em all
		switch (1) {
			$WinaeroTweaker {Start-DownloadLoop $dl1 winaero.zip "Winaero Tweaker"}
			$OpenShell {Start-DownloadLoop $dl2 openshellinstaller.exe "Open-Shell"}
			$TClock {Start-DownloadLoop $dl4 tclock.zip "TClock"}
			$Firefox {Start-DownloadLoop $dl6 firefoxesr.exe "Firefox ESR"}
			$NPP {Start-DownloadLoop $dl8 npp.exe "Notepad++"}
			$ShareX {Start-DownloadLoop $dl9 sharex462.exe "ShareX"}
			$VLC {Start-DownloadLoop $dlX "vlc-${VLCver}-win64.exe" "VLC"}
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
	Start-BitsTransfer -DisplayName "Downloading .NET 4.6.2" -Description " " -Source $462dl -Destination $datadir\dls\dotnet462.exe
}

$wu = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).WUmode
$ngawarn = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).SkipNotGABWarn
if ($wu -eq 1 -and $ngawarn -ne 1) {
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "`r`nDownloading and installing PSWindowsUpdate"
	$thpm = "$env:SYSTEMDRIVE\Program Files\WindowsPowerShell\Modules\PackageManagement"
	if ($build -lt 14393 -and (Test-Path -Path "$thpm\1.0.0.1") -eq $false) {Expand-Archive -Path $datadir\utils\THPM.zip -DestinationPath "$thpm\1.0.0.1"; Write-Warning "You may get errors related to NuGet, and that's normal."}
	$pswucheck = 1
	while ($pswucheck -le 5) {
		if ($build -ge 14393) {
			Install-PackageProvider -Name 'NuGet' -Verbose -Force
			Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
			Add-Type -AssemblyName presentationCore
			Install-Module PSWindowsUpdate -Verbose
		} else {
			Start-Process powershell -Wait -ArgumentList "-NonInteractive -Command `"Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue; Write-Host 'Installing PSWindowsUpdate' -ForegroundColor Blue -BackgroundColor Gray; Write-Host ' '; Install-PackageProvider -Name NuGet -Verbose -Force; Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted; Add-Type -AssemblyName presentationCore; Install-Module PSWindowsUpdate -Verbose -RequiredVersion 2.2.0.2`""
		}
		if (Get-Module -ListAvailable -Name PSWindowsUpdate) {
			Write-Host -ForegroundColor Green "PSWindowsUpdate has been installed"
			Stop-DownloadMode 2
		} 
		else {
			Write-Host -ForegroundColor Red "Did PSWindowsUpdate fail to install? Retrying... (${pswucheck}/5)"
			$pswucheck++
			Start-Sleep -Seconds 2
		}
	}
	Write-Host -ForegroundColor Black -BackgroundColor Red "Failed to install PSWindowsUpdate. Windows Update mode has been disabled."
}

Stop-DownloadMode 1
