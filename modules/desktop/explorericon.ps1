Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting Explorer icon to 1903+"
Expand-Archive -Path $datadir\utils\explorer.zip -DestinationPath $datadir\utils
Copy-Item -Path $datadir\utils\explorer.ico -Destination $env:SYSTEMDRIVE\Windows\explorer.ico
Copy-Item -Path $datadir\utils\explorer.lnk -Destination "$env:appdata\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk"
Copy-Item -Path $datadir\utils\explorer.lnk -Destination "$env:appdata\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\File Explorer.lnk"
Start-Process ie4uinit -ArgumentList "-show"
Start-Process ie4uinit -ArgumentList "-show"
Start-Process ie4uinit -ArgumentList "-show"
Stop-Process -Name "explorer" -Force
Start-Process 'explorer.exe' 
