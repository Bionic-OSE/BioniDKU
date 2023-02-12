$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Music fetcher module"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "Music fetcher module" -ForegroundColor Cyan -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
$mexists = Test-Path -Path "$PSScriptRoot\normal"
if ($mexists -eq $true) {exit}

Show-Branding
Import-Module BitsTransfer
$m1 = "https://github.com/Bionic-OSE/BioniDKU-music/raw/music/normal.7z.001"
$m2 = "https://github.com/Bionic-OSE/BioniDKU-music/raw/music/normal.7z.002"
$m3 = "https://github.com/Bionic-OSE/BioniDKU-music/raw/music/normal.7z.003"
$m4 = "https://github.com/Bionic-OSE/BioniDKU-music/raw/music/normal.7z.004"
$m5 = ""
$m6 = ""
$m7 = ""
Start-BitsTransfer -Source $m1 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
Start-BitsTransfer -Source $m2 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
Start-BitsTransfer -Source $m3 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
Start-BitsTransfer -Source $m4 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
#Start-BitsTransfer -Source $m5 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
#Start-BitsTransfer -Source $m6 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
#Start-BitsTransfer -Source $m7 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70

Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "e $PSScriptRoot\normal.7z.001 -o$PSScriptRoot\normal"
Write-Host " "
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Extraction complete." -n; Write-Host " (Ignore the warnings tho, the files should be fine.)"
Write-Host -ForegroundColor Yellow "Some of the songs featured in this (nearly infinite) collection might be copyrighted. If you are planning to record and upload this run to public platforms, please beware of that. You can view this collection in $PSScriptRoot\normal"
Write-Host -ForegroundColor Yellow "Continuing in 10 seconds" -n; Write-Host " (or you can skip by pressing Ctrl+C)"
Start-Sleep -Seconds 10
