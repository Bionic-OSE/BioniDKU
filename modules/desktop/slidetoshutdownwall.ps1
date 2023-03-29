Write-Host "Changing the background for SlideToShutdown.exe" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host " (given that you set the default ones in Settings)" -ForegroundColor White

function Remove-SystemFile($item) {
	takeown /f $item /r
	icacls $item /grant Administrators:F /t
	Remove-Item -Path $item -Force -Recurse -ErrorAction SilentlyContinue
}
function Copy-Images($imgsrc,$imgxxx) {
	Copy-Item -Path $env:SYSTEMDRIVE\Windows\Web\Screen\$imgsrc -Destination "$env:SYSTEMDRIVE\Windows\Web\Screen\$imgxxx"
}

Remove-SystemFile $env:SYSTEMDRIVE\Windows\Web\Screen
$newwall = (Test-Path -Path "$env:SYSTEMDRIVE\Windows\Web\Screen")
if ($newwall -eq $false) {New-Item -Path "C:\Windows\Web" -Name "Screen" -ItemType directory}
Expand-Archive -Path $workdir\utils\Screen.zip -DestinationPath $env:SYSTEMDRIVE\Windows\Web\Screen
Copy-Images img100.jpg img102.jpg
Copy-Images img100.jpg img104.jpg
Copy-Images img100.jpg img105.jpg
Copy-Images img101.png img103.png
