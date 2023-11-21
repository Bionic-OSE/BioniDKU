# BioniDKU Windows Update mode - A decicated mode with a lightweight shell just to run Windows Update
# The purpose is so that the system can focus on the task at hand, without too much resources being used by the regular Explorer shell

function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Windows Update mode" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "; Write-OSInfo; Write-Host " "
}
function Stop-UpdateMode {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 1 -Type DWord -Force
	Start-Sleep -Seconds 5
	Stop-Process -Name "WinXShell" -Force -ErrorAction SilentlyContinue
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMusicStop" -Value 1 -Type DWord -Force
	Stop-Process -Name "FFPlay" -Force -ErrorAction SilentlyContinue
	Remove-Item -Path "$env:SYSTEMDRIVE\Bionic\WinXShell" -Recurse -Force
	exit
}
function Stop-UpdateModeSuccess {
	Start-Process "$datadir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainCompleted.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
	Write-Host "The latest updates have been installed." -ForegroundColor Green -BackgroundColor DarkGray -n; Write-Host " Leaving Windows Update mode..."
	Stop-UpdateMode
}
function Stop-UpdateModeAborted {
	Start-Process "$datadir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainFailed.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
	Write-Host "You have aborted updates." -ForegroundColor Yellow -BackgroundColor DarkGray -n; Write-Host " Leaving Windows Update mode..."
	Stop-UpdateMode
}
function Start-HikaruMusicAndShell {
	Start-Process "$datadir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainChallengeStart.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
	if ($hkau -eq 1) {Start-Process powershell -ArgumentList "-Command $coredir\music\musicplayer.ps1"}
	$hkws = Test-Path -Path "$env:SYSTEMDRIVE\Bionic\WinXShell"
	if ($hkws -eq $false) {
		Expand-Archive -Path $datadir\utils\WinXShell.zip -DestinationPath $env:SYSTEMDRIVE\Bionic\WinXShell
		$ds = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").DarkSakura
		if ($ds -eq 1) {Move-Item "$env:SYSTEMDRIVE\Bionic\WinXShell\sakuraground.jpg" -Destination "$env:SYSTEMDRIVE\Bionic\WinXShell\background.jpg" -Force}
		Write-Host "Starting WinXShell" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ", a lightweight desktop environment used in Windows Preinstalled Environments (Windows PE)"
	}
	Start-Process "$env:SYSTEMDRIVE\Bionic\WinXShell\WinXShell.exe"
	Start-Sleep -Seconds 5
}
function Start-Wumgr {
	Write-Host " "
	Write-Host "Starting Windows Update mode with Wumgr" -ForegroundColor Cyan -BackgroundColor DarkGray
	Start-HikaruMusicAndShell
	$hkwumgr = Test-Path -Path "$datadir\utils\Wumgr"
	if ($hkwumgr -eq $false) {
		Expand-Archive -Path $workdir\utils\Wumgr.zip -DestinationPath $datadir\utils\Wumgr
	}
	Start-Process "$datadir\utils\Wumgr\wumgr.exe" -Wait
	Restart-UpdateMode
}
function Restart-UpdateMode {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootConfirm" -Value 1 -Type DWord -Force
	Start-Process powershell -Wait -ArgumentList "-Command $coredir\support\hikancel.ps1"
	$hkbrb = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").RebootConfirm
	if ($hkbrb -eq 0) {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Restarting to finish installing updates"
		Start-Sleep -Seconds 2
		Restart-System
	} else {
		Stop-UpdateModeSuccess
	}
}
function Show-StuckHelp {
	$targetcheck = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue).TargetReleaseVersion
	if ($targetcheck -eq 1 -and $edition -notmatch "Core" -and $build -ge 17134) {
		Write-Host " "
		Write-Host "HINT: " -ForegroundColor Magenta -n; Write-Host "If you got stuck at a Feature Update, try the following fix" -ForegroundColor Cyan
		Write-Host "- Start Windows Update mode with Wumgr (option 2)"
		Write-Host "- Open Registry Editor via the Run dialog like usual and nagivate to"
		Write-Host "  HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ForegroundColor White
		Write-Host "- Change value" -n; Write-Host ' "TargetReleaseVersionInfo" ' -ForegroundColor White -n; Write-Host "to an older version"
		Write-Host "  (say if it's 2004, change it to 1909)"
		Write-Host "- Then, switch value" -n; Write-Host ' "TargetReleaseVersion" ' -ForegroundColor White -n; Write-Host "to 0"
		Write-Host '- After that, via Run, open a Command Prompt and type ' -n; Write-Host '"powershell Restart-Service -Name wuauserv"' -ForegroundColor White
		Write-Host "- Switch value" -n; Write-Host ' "TargetReleaseVersion" ' -ForegroundColor White -n; Write-Host "back to 1"
		Write-Host "- Run the restart service command again"
		Write-Host "- Finally check for updates in Wumgr. If update shows and it's not a Feature Update, you fixed it!"
		Write-Host "- If the problem can't still be solved, try repeating from step 4 again. And if it still does no extra damage,"
		Write-Host "  your only choice then is to give Microsoft a middle finger, and abort WU mode."
	}
}

$global:workdir = Split-Path(Split-Path "$PSScriptRoot")
$global:coredir = Split-Path "$PSScriptRoot"
$global:datadir = "$workdir\data"

. $coredir\kernel\osinfo.ps1
Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Titlebar.psm1
Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Logging.psm1

Show-WindowTitle 2.2 "Windows Update mode"
Start-Logging WUMode
Show-Branding

. $datadir\dls\PATCHME.ps1
$bubr = $latest | Select-String -Pattern $build
$lubr = $bubr.Line.Substring($bubr.Line.LastIndexOf(".")+1)
if ([int]$ubr -ge [int]$lubr) {Set-ItemProperty -Path "HKCU:\Software\AutoIDKU"  -Name "Wupdated" -Value 1 -Type DWord -Force}
$wupdated = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Wupdated
$global:hkau = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic

Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Hikareboot" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Hikancel" -Value 1 -Type DWord -Force
Start-Process powershell -Wait -ArgumentList "-Command $coredir\support\hikancel.ps1"
$hkc = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Hikancel
if ($hkc -eq 1) {
	if ($wupdated -eq 1) {
		Write-Host " "
		Write-Host -ForegroundColor Yellow "What do you want to do?"
		Write-Host -ForegroundColor White "1. Continue updating"
		Write-Host -ForegroundColor White "2. Continue updating using Wumgr"
		Write-Host -ForegroundColor White "0. Leave Windows Update mode" -n; Write-Host " (Default answer)"
		Write-Host " "
		Write-Host "Your selection: " -n ; $hkchoice = Read-Host
		switch ($hkchoice) {
			{$_ -eq 1} {Write-Host -ForegroundColor Cyan "Alright, under your command..."}
			{$_ -eq 2} {Start-Wumgr}
			default {Stop-UpdateModeSuccess}
		}
	} else {
		Write-Host " "
		Write-Host -ForegroundColor Yellow "What do you want to do?"
		Write-Host -ForegroundColor White "1. Abort updating and leave Windows Update mode"
		Write-Host -ForegroundColor White "2. Switch to Wumgr for this session"
		Write-Host -ForegroundColor White "0. Continue updating" -n; Write-Host " (Default answer)"
		Show-StuckHelp
		Write-Host " "
		Write-Host "Your selection: " -n ; $hkchoice = Read-Host
		switch ($hkchoice) {
			{$_ -eq 2} {Start-Wumgr}
			{$_ -eq 1} {Stop-UpdateModeAborted}
			default {Write-Host -ForegroundColor Cyan "Alright, then we will proceed as usual"}
		}
	}
} else {
	if ($wupdated -eq 1) {Stop-UpdateModeSuccess}
}
Write-Host " "
Write-Host "Starting Windows Update mode normally" -ForegroundColor Cyan -BackgroundColor DarkGray

Start-HikaruMusicAndShell

Write-Host "Getting Windows ready" -ForegroundColor Cyan -BackgroundColor DarkGray
if ($wupdated -ne 1) {& $coredir\support\cWUngus.ps1}
Import-Module PSWindowsUpdate

Write-Host " "
Write-Host -ForegroundColor Cyan "Updating the system until it reaches the desired UBR"
Restart-Service -Name wuauserv
Write-Host -ForegroundColor White "Checking for updates"; Get-WUList
Write-Host -ForegroundColor White "Checking for updates again and installing all updates found"; Get-WUList -AcceptAll -Install -NotCategory 'Upgrade' -IgnoreReboot | Out-Null

Restart-UpdateMode
