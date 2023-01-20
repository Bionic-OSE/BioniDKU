$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter and Sunryze | Windows Update mode"
$butter = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Butter
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "Windows Update mode" -ForegroundColor Cyan -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
Show-Branding

Write-Host "To abort updating and leave Windows Update mode, press CTRL+C in 10 seconds." -ForegroundColor Black -BackgroundColor Cyan -n; Write-Host ([char]0xA0)
Start-Sleep -Seconds 10
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Hikancel" -Value 0 -Type DWord -Force