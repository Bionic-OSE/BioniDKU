Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting Explorer icon to 1903+" -n; Write-Host ([char]0xA0)
Expand-Archive -Path $workdir\utils\explorer.zip -DestinationPath $workdir\utils
Copy-Item -Path $workdir\utils\explorer.ico -Destination C:\Windows\explorer.ico
Copy-Item -Path $workdir\utils\explorer.lnk -Destination "$env:appdata\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk"
Copy-Item -Path $workdir\utils\explorer.lnk -Destination "$env:appdata\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\File Explorer.lnk"
Start-Process ie4uinit -ArgumentList "-show"
Start-Process ie4uinit -ArgumentList "-show"
Start-Process ie4uinit -ArgumentList "-show"
Stop-Process -Name "explorer" -Force
Start-Process 'explorer.exe' 
