# BioniDKU Windows Update mode - Interrupt prompt - (c) Bionic Butter

$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | WU mode interrupter"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Windows Update mode" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}
function Show-WaitTime($wti) {
	for ($wt = $wti; $wt -ge 1; $wt--) {
		$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | WU mode interrupter | $wt seconds remaining..."
		Start-Sleep -Seconds 1
	}
}

$wupdated = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Wupdated
$wureboot = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Wureboot
if ($wupdated -eq 1) {
	if ($wureboot -eq 1) {
		Show-Branding
		Write-Host "Your system have reached or passed the desired UBR." -ForegroundColor Black -BackgroundColor Green -n; Write-Host " If there were no additional updates, you can press CTRL+C to leave Windows Update mode within 10 seconds." -ForegroundColor Cyan
		Show-WaitTime 10
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Wureboot" -Value 0 -Type DWord -Force
		exit
	} else {
		Show-Branding
		Write-Host "Your system have reached or passed the desired UBR." -ForegroundColor Black -BackgroundColor Green -n; Write-Host " If you wish to continue updating, press CTRL+C within 10 seconds." -ForegroundColor Cyan
		Show-WaitTime 10
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Wucancel" -Value 0 -Type DWord -Force
		exit
	}
} elseif ($wureboot -eq 1) {Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Wureboot" -Value 0 -Type DWord -Force; exit}
else {
	Show-Branding
	Write-Host "To interrupt Windows Update mode, press CTRL+C within 10 seconds." -ForegroundColor Black -BackgroundColor Cyan
	Show-WaitTime 10
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Wucancel" -Value 0 -Type DWord -Force
	exit
}
