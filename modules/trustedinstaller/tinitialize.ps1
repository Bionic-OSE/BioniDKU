$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter and Sunryze | TrustedInstaller is starting..."
# TrustedInstaller environment preparation phase
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "Starting TrustedInstaller" -ForegroundColor Yellow -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
Show-Branding

Start-Process "$env:SYSTEMDRIVE\Windows\System32\whoami.exe" -Wait -NoNewWindow
Start-Sleep -Seconds 3

