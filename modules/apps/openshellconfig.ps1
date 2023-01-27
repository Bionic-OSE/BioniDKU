Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Import OpenShell configuration" -n; Write-Host ([char]0xA0)
Start-Process "$env:ProgramFiles\Open-Shell\StartMenu.exe" -NoNewWindow -ArgumentList "-xml $workdir\utils\menu.xml"
