Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing Custom system sounds" -n; Write-Host ([char]0xA0)

#Expand-Archive -Path $workdir\utils\longhorn.zip -DestinationPath $workdir
#$longhorn = (Test-Path -Path "C:\Windows\Media\Longhorn")
#if ($longhorn -eq $true) {Remove-Item -Path "C:\Windows\media" -Name "Longhorn" }
#Copy-Item -Path $workdir\longhorn -Destination "C:\Windows\Media\Longhorn" -Recurse -Force
#reg.exe import $workdir\longhorn.reg

Write-Host -ForegroundColor Cyan "Removing old system sounds with 5 passes, starting in 3 seconds"
takeown /f $env:SYSTEMDRIVE\Windows\Media /r
icacls $env:SYSTEMDRIVE\Windows\Media /grant Administrators:F /t
Remove-Item -Path $env:SYSTEMDRIVE\windows\Media -Force -Recurse -ErrorAction SilentlyContinue
Write-Host -ForegroundColor Cyan "Pass 1/5 complete, next in 3 seconds" -n; Write-Host " (you may see errors and that's normal)"
Start-Sleep -Seconds 3
takeown /f $env:SYSTEMDRIVE\Windows\Media /r
icacls $env:SYSTEMDRIVE\Windows\Media /grant Administrators:F /t
Remove-Item -Path $env:SYSTEMDRIVE\windows\Media -Force -Recurse -ErrorAction SilentlyContinue
Write-Host  -ForegroundColor Cyan "Pass 2/5 complete, next in 3 seconds" -n; Write-Host " (you may see errors and that's normal)"
Start-Sleep -Seconds 3
takeown /f $env:SYSTEMDRIVE\Windows\Media /r
icacls $env:SYSTEMDRIVE\Windows\Media /grant Administrators:F /t
Remove-Item -Path $env:SYSTEMDRIVE\windows\Media -Force -Recurse -ErrorAction SilentlyContinue
Write-Host -ForegroundColor Cyan "Pass 3/5 complete, next in 3 seconds" -n; Write-Host " (you may see errors and that's normal)"
Start-Sleep -Seconds 3
takeown /f $env:SYSTEMDRIVE\Windows\Media /r
icacls $env:SYSTEMDRIVE\Windows\Media /grant Administrators:F /t
Remove-Item -Path $env:SYSTEMDRIVE\windows\Media -Force -Recurse -ErrorAction SilentlyContinue
Write-Host -ForegroundColor Cyan "Pass 4/5 complete, next in 3 seconds" -n; Write-Host " (you may see errors and that's normal)"
Start-Sleep -Seconds 3
takeown /f $env:SYSTEMDRIVE\Windows\Media /r
icacls $env:SYSTEMDRIVE\Windows\Media /grant Administrators:F /t
Remove-Item -Path $env:SYSTEMDRIVE\windows\Media -Force -Recurse -ErrorAction SilentlyContinue
Write-Host -ForegroundColor Cyan "Pass 5/5 complete, now placing new sounds in 3 seconds"
Start-Sleep -Seconds 3

$newmedia = (Test-Path -Path "C:\Windows\Media")
if ($newmedia -eq $false) {New-Item -Path "C:\Windows" -Name "Media" -ItemType directory}
Expand-Archive -Path $workdir\utils\Media8.zip -DestinationPath C:\Windows\Media
