if ($edition -like "Core*" -or $edition -like "Server*") {exit}
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Hiding the loading screens completely"
Enable-WindowsOptionalFeature -Online -FeatureName "Client-EmbeddedLogon" -All -NoRestart
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon' -Name HideAutoLogonUI -Value 1 -Type DWord -Force 
