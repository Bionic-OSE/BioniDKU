$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Windows Update mode"
$butter = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Butter
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "Windows Update mode" -ForegroundColor Blue -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}

$wupdated = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Wupdated
$hikareboot = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Hikareboot
if ($wupdated -eq 1) {
	if ($hikareboot -eq 1) {
		Show-Branding
		Write-Host "Your system have reached the desired UBR." -ForegroundColor Black -BackgroundColor Green -n; Write-Host " If there were no additional updates, you can press CTRL+C to leave Windows Update mode within 15 seconds." -ForegroundColor Cyan -n; Write-Host ([char]0xA0)
		Start-Sleep -Seconds 15
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Hikareboot" -Value 0 -Type DWord -Force
	} else {
		Show-Branding
		Write-Host "Your system have reached the desired UBR." -ForegroundColor Black -BackgroundColor Green -n; Write-Host " If you wish to continue updating, press CTRL+C within 15 seconds." -ForegroundColor Cyan -n; Write-Host ([char]0xA0)
		Start-Sleep -Seconds 15
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Hikancel" -Value 0 -Type DWord -Force
	}
} elseif ($hikareboot -eq 1) {Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Hikareboot" -Value 0 -Type DWord -Force}
else {
	Show-Branding
	Write-Host "To interrupt Windows Update mode, press CTRL+C within 10 seconds." -ForegroundColor Black -BackgroundColor Cyan -n; Write-Host ([char]0xA0)
	Start-Sleep -Seconds 10
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Hikancel" -Value 0 -Type DWord -Force
}

