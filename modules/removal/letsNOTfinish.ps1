$letsdestroy = Test-Path -Path "$env:SYSTEMDRIVE\windows\system32\wwahost.exe" -PathType Leaf
if ($letsdestroy -eq $false) {exit}
if ($build -ge 18362) {
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Let's NOT finish setting up your device" -n; Write-Host ([char]0xA0)
	Write-Host '(You do not want to get that thing interrupting the automation.)'
	Write-Host 'More information about this: https://youtu.be/jtQCLgba4Xg'
	Start-Sleep -Seconds 2
	Write-Host -ForegroundColor Cyan "Destroying wwahost.exe" -n; Write-Host " (I'm sorry I had to go evil, this thing is TOUGH)"
}
takeown /f $env:SYSTEMDRIVE\windows\system32\wwahost.exe
icacls $env:SYSTEMDRIVE\windows\system32\wwahost.exe /grant Administrators:F
Copy-Item -Path $env:SYSTEMDRIVE\Windows\System32\wwahost.exe -Destination $env:SYSTEMDRIVE\Bionic\Hikaru\wwahost.QUARANTINE
Remove-Item -Path $env:SYSTEMDRIVE\Windows\system32\wwahost.exe -Force
Start-Sleep -Seconds 2
