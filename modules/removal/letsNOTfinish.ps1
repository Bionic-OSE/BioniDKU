# This module will soon be discarded, as experiments have shown that it doesn't work well. Version 201 will adapt the whole script's working mechanism to this situation

$letsdestroy = Test-Path -Path 'C:\windows\system32\wwahost.exe' -PathType Leaf
if ($letsdestroy -eq $false) {exit}
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Let's NOT finish setting up your device" -n; Write-Host ([char]0xA0)
$letsgo = 
Write-Host '(YES, RIGHT NOW. You do not want to get that thing interrupting the automation after updating.'
Write-Host 'More information about this: https://youtu.be/jtQCLgba4Xg'
Start-Sleep -Seconds 2
# letsexist = Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement'
# if ($letsexist -eq $false) {New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion' -Name UserProfileEngagement}
# Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement' -Name 'ScoobeSystemSettingsEnabled' -Value 0 -Type DWord -Force
Write-Host -ForegroundColor Cyan "Destroying wwahost.exe" -n; Write-Host " (I'm sorry I had to go evil, this thing is TOUGH)"
takeown /f C:\windows\system32\wwahost.exe
icacls C:\windows\system32\wwahost.exe /grant Administrators:F
Remove-Item -Path C:\windows\system32\wwahost.exe -Force
Start-Sleep -Seconds 2