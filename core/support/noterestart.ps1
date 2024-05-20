# BioniDKU end-of-script automatic restart background counter - (c) Bionic Butter

$workdir = Split-Path(Split-Path "$PSScriptRoot")
$coredir = Split-Path "$PSScriptRoot"

Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Support.psm1
. $coredir\kernel\minihikaru.ps1
Start-Sleep -Seconds 60
Wait-Process -Name FFPlay
Set-HikaruChan runonce
Restart-System ManualExit
