$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter and Sunryze | Utilites fetcher module"
$uexists = Test-Path -Path "$PSScriptRoot\ambient.zip" -PathType Leaf
if ($uexists -eq $true) {exit}
function Show-Branding { # Has to declare it here again because of a different PowerShell process
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "Utilites fetcher module" -ForegroundColor Cyan -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
Show-Branding
Import-Module BitsTransfer

# Lesson learned from 201_b1: Don't pull from the latest, but rather from a specific tag
$u1 = "https://github.com/Bionic-OSE/BioniDKU-utils/releases/download/201_b3a/utils.7z.001"
$u2 = "https://github.com/Bionic-OSE/BioniDKU-utils/releases/download/201_b3a/utils.7z.002"
$u3 = "https://github.com/Bionic-OSE/BioniDKU-utils/releases/download/201_b3a/utils.7z.003"
#$u4 = "https://github.com/Bionic-OSE/BioniDKU-utils/releases/download/201_xx/utils.7z.004"
Start-BitsTransfer -Source $u1 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
Start-BitsTransfer -Source $u2 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
Start-BitsTransfer -Source $u3 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
#Start-BitsTransfer -Source $u4 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "e $PSScriptRoot\utils.7z.001 -o$PSScriptRoot"
