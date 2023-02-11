Write-Host "Changing the background for SlideToShutdown.exe" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)

Remove-Item -Path $env:SYSTEMDRIVE\Windows\Web\Screen -Force -Recurse -ErrorAction SilentlyContinue
$newwall = (Test-Path -Path "$env:SYSTEMDRIVE\Windows\Web\Screen")
if ($newwall -eq $false) {New-Item -Path "C:\Windows\Web" -Name "Screen" -ItemType directory}
Expand-Archive -Path $workdir\utils\Screen.zip -DestinationPath $env:SYSTEMDRIVE\Windows\Web\Screen
function Copy-Images($imgsrc,$imgxxx) {
	Copy-Item -Path $env:SYSTEMDRIVE\Windows\Web\Screen\$imgsrc -DestinationPath "$env:SYSTEMDRIVE\Windows\Web\Screen\$imgxxx"
}
Copy-Images img100.jpg img102.jpg
Copy-Images img100.jpg img104.jpg
Copy-Images img100.jpg img105.jpg
Copy-Images img101.png img103.png
