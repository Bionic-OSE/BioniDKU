Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing Custom system sounds" -n; Write-Host ([char]0xA0)

#Expand-Archive -Path $workdir\utils\longhorn.zip -DestinationPath $workdir
#$longhorn = (Test-Path -Path "C:\Windows\Media\Longhorn")
#if ($longhorn -eq $true) {Remove-Item -Path "C:\Windows\media" -Name "Longhorn" }
#Copy-Item -Path $workdir\longhorn -Destination "C:\Windows\Media\Longhorn" -Recurse -Force
#reg.exe import $workdir\longhorn.reg

Write-Host -ForegroundColor Cyan "Removing old system sounds with 3 passes"
takeown /f C:\Windows\Media
takeown /f C:\Windows\Media\*.*
icacls C:\Windows\Media /grant Administrators:F
icacls C:\Windows\Media\*.* /grant Administrators:F
Remove-Item -Path C:\windows\Media -Force -Recurse
Write-Host "Pass 1/3 complete, next in 3 seconds (you may see an error and that's normal)"
Start-Sleep -Seconds 3
takeown /f C:\Windows\Media
takeown /f C:\Windows\Media\*.*
icacls C:\Windows\Media /grant Administrators:F
icacls C:\Windows\Media\*.* /grant Administrators:F
Remove-Item -Path C:\windows\Media -Force -Recurse
Write-Host "Pass 2/3 complete, next in 3 seconds (you may see an error and that's normal)"
Start-Sleep -Seconds 3
takeown /f C:\Windows\Media
takeown /f C:\Windows\Media\*.*
icacls C:\Windows\Media /grant Administrators:F
icacls C:\Windows\Media\*.* /grant Administrators:F
Remove-Item -Path C:\windows\Media -Force -Recurse
Write-Host "Pass 3/3 complete, now placing new sounds in 3 seconds"
Start-Sleep -Seconds 3

$newmedia = (Test-Path -Path "C:\Windows\Media")
if ($newmedia -eq $false) {New-Item -Path "C:\Windows" -Name "Media" -ItemType directory}
Expand-Archive -Path $workdir\utils\Media8.zip -DestinationPath C:\Windows\Media