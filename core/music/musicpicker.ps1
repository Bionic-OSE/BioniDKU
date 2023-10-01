# Music picker module, part of the main menu - Still in the works

& $coredir\music\musicheck.ps1
Show-Branding clear

Write-Host -ForegroundColor Yellow "This feature is currently in development. Stay tuned for future updates!"
Write-Host "For now, if you want to customize your music selection, follow these steps:"
Write-Host "- Navigate to" -n; Write-Host " HKCU\SOFTWARE\AutoIDKU\Music " -ForegroundColor White
Write-Host "- You should see five REG_DWORD values inside the" -n; Write-Host ' "Music" ' -ForegroundColor White -n; Write-Host "key, going from 1 to 5"
Write-Host "- Those values correspond to these categories below. Refer to this list to adjust your selection."
Write-Host "  (Set to the value 1 to select the category, or 0 to unselect)"
Write-Host -ForegroundColor Green "  1. Touhou OSTs"
Write-Host -ForegroundColor Green "  2. Genshin Impact OSTs"
Write-Host -ForegroundColor Green "  3. Deltarune OSTs"
Write-Host -ForegroundColor Green "  4. Undertale OSTs"
Write-Host -ForegroundColor Green "  5. Featured Artists"
Write-Host "- FYI, categories from 1 to 4 are game sound tracks. You can look up on the internet about those games. As for category 5, it features works from independent composers or artists groups that I hand-picked. I will be providing detailed information about 1 to 4 in a future update, stay tuned for that too!"
Write-Host "- The selected categories will be downloaded during script execution, and all songs within all collections will be played in shuffle."
Write-Host " "
Write-Host -ForegroundColor Yellow "Press Enter to return to the previous menu."
Read-Host
