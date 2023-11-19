. $workdir\modules\lib\DestructionsBlessing.ps1
$letsdestroy = Test-Path -Path "$env:SYSTEMDRIVE\windows\system32\wwahost.exe" -PathType Leaf
if ($letsdestroy -eq $false) {exit}
if ($build -ge 18362) {
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Let's NOT finish setting up your device"
	Write-Host '(You do not want to get that thing interrupting the automation.)'
	Write-Host 'More information about this: https://youtu.be/jtQCLgba4Xg'
	Start-Sleep -Seconds 1
	Write-Host -ForegroundColor Cyan "Destroying wwahost.exe" -n; Write-Host " (I'm sorry I had to go evil, this thing is TOUGH)"
}
Copy-Item -Path $env:SYSTEMDRIVE\Windows\System32\wwahost.exe -Destination $env:SYSTEMDRIVE\Bionic\Hikaru\wwahost.QUARANTINE
Remove-SystemFile F $env:SYSTEMDRIVE\Windows\system32\wwahost.exe
Start-Sleep -Seconds 1
