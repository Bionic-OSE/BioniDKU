Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Clearing any pending script resume orders" -n; Write-Host ([char]0xA0)
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 0 -Type DWord -Force
$resumer = Test-Path -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\resume.lnk" -PathType Leaf
$resumar = Test-Path -Path "C:\Windows\resume.bat" -PathType Leaf
if ($resumer -eq $true) {Remove-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\resume.lnk"}
if ($resumar -eq $true) {Remove-Item "C:\Windows\resume.bat"}