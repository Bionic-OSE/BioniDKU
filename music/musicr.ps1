# This redstone2 only activates when a certain condition is met... 
# Wanna look for an answer? Check out modules/essential/cWUngus.ps1!

$rexists = Test-Path -Path "$PSScriptRoot\redstone2"
if ($rexists -eq $true) {exit}

Import-Module BitsTransfer
$r1 = "https://github.com/Bionic-OSE/BioniDKU-music/raw/music/redstone2.7z.001"
$r2 = "https://github.com/Bionic-OSE/BioniDKU-music/raw/music/redstone2.7z.002"
Start-BitsTransfer -Source $r1 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70
Start-BitsTransfer -Source $r2 -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70

Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "e $PSScriptRoot\redstone2.7z.001 -o$PSScriptRoot\redstone2"
