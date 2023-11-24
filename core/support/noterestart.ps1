$workdir = Split-Path(Split-Path "$PSScriptRoot")
Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Logging.psm1
Start-Sleep -Seconds 60
Wait-Process -Name FFPlay
Restart-System ManualExit
