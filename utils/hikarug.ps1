# This module gets the core components required for the script to start properly, part of Nana the bootloader

$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Getting critical components... - DO NOT CLOSE THIS WINDOW"
$hexists = Test-Path -Path "$PSScriptRoot\Hikare.7z" -PathType Leaf
if ($hexists) {exit}
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Getting critical components..." -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}
Show-Branding
Import-Module BitsTransfer

function Start-DownloadLoop($link,$destfile,$name,$descr) {
	while ($true) {
		Start-BitsTransfer -DisplayName "$name" -Description "$descr" -Source $link -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		if (Test-Path -Path "$PSScriptRoot\$destfile" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor Black -BackgroundColor Red "Ehhhhhhh"
			Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
		}
	}
}
Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikaru.7z" "Hikaru.7z" "Getting Hikaru-chan" "Downloading soft (script) layer"
Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikare.7z" "Hikare.7z" "Getting Hikaru-chan" "Downloading hard (executables) layer"
Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikarup.7z" "Hikarup.7z" "Getting Hikaru-chan" "Downloading servicing layer"
Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikarinfo.ps1" "Hikarinfo.ps1" "Getting Hikaru-chan" "Downloading release information file"
Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-utils/raw/utils/active/ambient.zip" "ambient.zip" "Getting ambient sounds package" " "
Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-utils/raw/utils/active/background.png" "background.png" "Getting desktop background image" " "
Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-utils/raw/utils/active/sakuraground.png" "sakuraground.png" "Getting desktop background image" " "

if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic") -eq $false) {New-Item -Path $env:SYSTEMDRIVE -Name Bionic -itemType Directory | Out-Null}
Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "x $PSScriptRoot\Hikaru.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic"
Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "x $PSScriptRoot\Hikare.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic"
Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "x $PSScriptRoot\Hikarup.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic"
. $PSScriptRoot\Hikarinfo.ps1
New-Item -Path 'HKCU:\SOFTWARE' -Name Hikaru-chan
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "Version" -Value "22108.$version" -Force
Move-Item -Path "$PSScriptRoot\Hikarinfo.ps1" -Destination "$env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarinFOLD.ps1"