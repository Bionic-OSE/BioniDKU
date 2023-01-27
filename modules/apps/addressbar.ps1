Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling address bar" -n; Write-Host ([char]0xA0)
Copy-Item -Path $workdir\utils\AddressBarRemover2.exe -Destination "$env:Appdata\Microsoft\Windows\Start Menu\Programs\Startup\abr.exe"
Start-Process "$env:Appdata\Microsoft\Windows\Start Menu\Programs\Startup\abr.exe"
