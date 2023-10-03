if ($edition -match "Core" -or $editiontype -like "Server") {exit}
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Hiding the loading screens completely"
Enable-WindowsOptionalFeature -Online -FeatureName "Client-EmbeddedLogon" -All -NoRestart
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows Embedded")) {New-Item -Path "HKLM:\SOFTWARE\Microsoft" -Name "Windows Embedded"}
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon")) {New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows Embedded" -Name "EmbeddedLogon"}
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon' -Name HideAutoLogonUI -Value 1 -Type DWord -Force 
