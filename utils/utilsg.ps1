$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Utilites fetcher module"
$uexists = Test-Path -Path "$PSScriptRoot\ambient.zip" -PathType Leaf
if ($uexists) {exit}
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "Utilites fetcher module" -ForegroundColor Blue -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
Show-Branding
Import-Module BitsTransfer

# IMPORTANT SECTION
$utag = "201_b6b"
$unum = 3

for ($u = 1; $u -le $unum; $u++) {
	while ($true) {
		Start-BitsTransfer -Source "https://github.com/Bionic-OSE/BioniDKU-utils/releases/download/$utag/utils.7z.00$u" -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		if (Test-Path -Path "$PSScriptRoot\utils.7z.00$u" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor Black -BackgroundColor Red "Uhhhhhhh"
			Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
		}
	}
}
Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "e $PSScriptRoot\utils.7z.001 -o$PSScriptRoot"
while ($true) {
	Start-BitsTransfer -Source "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikaru.7z" -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
	if (Test-Path -Path "$PSScriptRoot\Hikaru.7z" -PathType Leaf) {break} else {
		Write-Host " "
		Write-Host -ForegroundColor Black -BackgroundColor Red "Ehhhhhhh"
		Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
	}
}
while ($true) {
	Start-BitsTransfer -Source "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikare.7z" -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
	if (Test-Path -Path "$PSScriptRoot\Hikare.7z" -PathType Leaf) {break} else {
		Write-Host " "
		Write-Host -ForegroundColor Black -BackgroundColor Red "Ehhhhhhh"
		Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
	}
}
while ($true) {
	Start-BitsTransfer -Source "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikarinfo.ps1" -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
	if (Test-Path -Path "$PSScriptRoot\Hikarinfo.ps1" -PathType Leaf) {break} else {
		Write-Host " "
		Write-Host -ForegroundColor Black -BackgroundColor Red "Ehhhhhhh"
		Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
	}
}
if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic") -eq $false) {New-Item -Path $env:SYSTEMDRIVE -Name Bionic -itemType Directory | Out-Null} #; if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikaru") -eq $false) {New-Item -Path $env:SYSTEMDRIVE\Bionic -Name Hikaru -itemType Directory | Out-Null}
Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "x $PSScriptRoot\Hikaru.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic"
Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "x $PSScriptRoot\Hikare.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic"
Move-Item -Path "$PSScriptRoot\Hikarinfo.ps1" -Destination "$env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarinFOLD.ps1"
