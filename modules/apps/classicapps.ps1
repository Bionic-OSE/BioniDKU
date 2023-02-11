Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing classic Taskmgr and msconfig" -n; Write-Host ([char]0xA0)
Expand-Archive -Path $workdir\utils\tm_cfg_win8-win10.zip -DestinationPath $workdir\dls
Start-Process $workdir\dls\tm_cfg_win8-win10.exe -NoNewWindow -Wait -ArgumentList "/SILENT"
