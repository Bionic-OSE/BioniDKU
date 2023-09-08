Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Explorer address bar"
Copy-Item -Path $workdir\utils\AddressBarRemover2.exe -Destination "$env:Appdata\Microsoft\Windows\Start Menu\Programs\Startup\AddressBarRemover2.exe"
