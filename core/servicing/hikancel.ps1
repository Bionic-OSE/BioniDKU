# Windows Update mode interrupt prompt

$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Windows Update mode"
$butter = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Butter
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Windows Update mode" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}
function Show-WaitTime($wti) {
	for ($wt = $wti; $wt -ge 1; $wt--) {
		$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Windows Update mode - $wt seconds remaining..."
		Start-Sleep -Seconds 1
	}
}

$wupdated = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Wupdated
$hikareboot = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Hikareboot
if ($wupdated -eq 1) {
	if ($hikareboot -eq 1) {
		Show-Branding
		Write-Host "Your system have reached or passed the desired UBR." -ForegroundColor Black -BackgroundColor Green -n; Write-Host " If there were no additional updates, you can press CTRL+C to leave Windows Update mode within 10 seconds." -ForegroundColor Cyan
		Show-WaitTime 10
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Hikareboot" -Value 0 -Type DWord -Force
		exit
	} else {
		Show-Branding
		$remote = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").RunningThisRemotely
		if ($remote -eq 1) {$sec = 30} else {$sec = 10}
		Write-Host "Your system have reached or passed the desired UBR." -ForegroundColor Black -BackgroundColor Green -n; Write-Host " If you wish to continue updating, press CTRL+C within $sec seconds." -ForegroundColor Cyan
		Show-WaitTime $sec
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Hikancel" -Value 0 -Type DWord -Force
		exit
	}
} elseif ($hikareboot -eq 1) {Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Hikareboot" -Value 0 -Type DWord -Force; exit}
else {
	Show-Branding
	$remote = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").RunningThisRemotely
	if ($remote -eq 1) {$sec = 30} else {$sec = 10}
	Write-Host "To interrupt Windows Update mode, press CTRL+C within $sec seconds." -ForegroundColor Black -BackgroundColor Cyan
	Show-WaitTime $sec
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Hikancel" -Value 0 -Type DWord -Force
	exit
}
