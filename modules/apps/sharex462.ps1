Write-Host "Installing ShareX 13.1.0" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
Start-BitsTransfer -Source 'https://github.com/ShareX/ShareX/releases/download/v13.1.0/ShareX-13.1.0-setup.exe' -Destination $workdir\sharex462.exe
Start-Process $workdir\sharex462.exe -Wait -NoNewWindow -ArgumentList "/VERYSILENT /NORUN"

Write-Host "Disabling ShareX's automatic update check"
$sxnou = Test-Path -Path "$env:USERPROFILE\Documents\ShareX"
if ($sxnou -eq $false) {
	New-Item -Path "$env:USERPROFILE\Documents" -Name ShareX -itemType Directory
}
Copy-Item -Path $workdir\utils\ApplicationConfig.json -Destination "$env:USERPROFILE\Documents\ShareX\ApplicationConfig.json"