$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Utilites fetcher module"
$uexists = Test-Path -Path "$PSScriptRoot\ambient.zip" -PathType Leaf
if ($uexists) {exit}
function Show-Branding { # Has to declare it here again because of a different PowerShell process
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "Utilites fetcher module" -ForegroundColor Cyan -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
Show-Branding
Import-Module BitsTransfer

function Start-UtilsDownload {
	$u1 = "https://github.com/Bionic-OSE/BioniDKU-utils/releases/download/201_b4a/utils.7z.001"
	$u2 = "https://github.com/Bionic-OSE/BioniDKU-utils/releases/download/201_b4a/utils.7z.002"
	$u3 = "https://github.com/Bionic-OSE/BioniDKU-utils/releases/download/201_b4a/utils.7z.003"
	#$u4 = "https://github.com/Bionic-OSE/BioniDKU-utils/releases/download/201_xx/utils.7z.004"
	Start-BitsTransfer -Source $u1 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
	Start-BitsTransfer -Source $u2 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
	Start-BitsTransfer -Source $u3 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
	#Start-BitsTransfer -Source $u4 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
}

while ($true) {
	Start-UtilsDownload
	$u1e = Test-Path -Path "$PSScriptRoot\utils.7z.001" -PathType Leaf
	$u2e = Test-Path -Path "$PSScriptRoot\utils.7z.002" -PathType Leaf
	$u3e = Test-Path -Path "$PSScriptRoot\utils.7z.003" -PathType Leaf
	if ($u1e -and $u2e -and $u3e) {
		Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "e $PSScriptRoot\utils.7z.001 -o$PSScriptRoot"
		break
	} else {
		Write-Host " "
		Write-Host -ForegroundColor Black -BackgroundColor Red "Uhhhhhhh"
		Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
	}
 }
 