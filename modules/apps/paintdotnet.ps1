Write-Host "Installing Paint.NET 4.0.19" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
Start-Process $workdir\utils\paintdotnet462.exe -NoNewWindow -Wait -ArgumentList "/AUTO"
