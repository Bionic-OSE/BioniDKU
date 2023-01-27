# This is NOT working. Perhaps the only way is to RMDIR without progress bar?
# UPDATE: Well I did, but still running into permission issues. Disabling it ahead of beta 3 release anyways

Write-Host "Removing WINDOWS.OLD as you requested" -ForegroundColor Red -BackgroundColor DarkGray -n; Write-Host " with 2 passes"

#Import-Module -Name $PSScriptRoot\..\lib\Remove-WinoldWP.psm1

#Write-Host "Pass 1/2: Attemping to remove with existing file permissions"
#Remove-WinoldWP -Path $env:SYSTEMDRIVE\Windows.old
#Write-Host "Pass 2/2: Takeowning the remaining files, and attempting to remove them once again"
takeown /f $env:SYSTEMDRIVE\Windows.old /r /d Y
#Remove-WinoldWP -Path $env:SYSTEMDRIVE\Windows.old
Start-Process $env:SYSTEMDRIVE\Windows\System32\cmd.exe -Wait -ArgumentList "/c `"rd $env:SYSTEMDRIVE\Windows.old /s /q`""

Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Removal complete" -n; Write-Host ([char]0xA0)
Start-Sleep -Seconds 5