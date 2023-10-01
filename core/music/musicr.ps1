# This redstone2 only activates when a certain condition is met... 

$global:workdir = Split-Path(Split-Path "$PSScriptRoot")
$global:coredir = Split-Path "$PSScriptRoot"
$global:datadir = "$workdir\data"
$rexists = Test-Path -Path "$datadir\redstone2"
if ($rexists -eq $true) {exit}

Import-Module BitsTransfer
if (-not (Test-Path -Path "$datadir\redstone2")) {New-Item -Path $datadir -Name "redstone2" -itemType Directory | Out-Null}
$r1 = "https://github.com/Bionic-OSE/BioniDKU-music/raw/music/redstone2.7z.001"
$r2 = "https://github.com/Bionic-OSE/BioniDKU-music/raw/music/redstone2.7z.002"
Start-BitsTransfer -Source $r1 -Destination $datadir\dls -RetryInterval 60 -RetryTimeout 70
Start-BitsTransfer -Source $r2 -Destination $datadir\dls -RetryInterval 60 -RetryTimeout 70

Start-Process $coredir\7z\7za.exe -Wait -NoNewWindow -ArgumentList "e $datadir\dls\redstone2.7z.001 -o$datadir\redstone2"
