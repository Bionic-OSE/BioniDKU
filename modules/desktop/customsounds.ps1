$workdir = "$PSScriptRoot\..\.."

$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Custom sound installer module"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Custom sound installer module" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}
Show-Branding

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing Custom system sounds"
function Remove-SystemFile($item) {
	takeown /f $item /r
	icacls $item /grant Administrators:F /t
	Remove-Item -Path $item -Force -Recurse -ErrorAction SilentlyContinue
}

Write-Host -ForegroundColor Cyan "Removing old system sounds until all files are gone, starting in 3 seconds"
while ($true) {
	Start-Sleep -Seconds 3
	$testmedia = (Test-Path -Path "$env:SYSTEMDRIVE\Windows\Media\*")
	if ($testmedia) {Remove-SystemFile $env:SYSTEMDRIVE\Windows\Media} else {break}
}

Write-Host -ForegroundColor Cyan "Old sounds have been removed, now placing new sounds in 3 seconds"
Start-Sleep -Seconds 3
$media10074 = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Media10074
if ($media10074 -eq 1) {$var = "1k74"} else {$var = "9600"}
New-Item -Path "$env:SYSTEMDRIVE\Windows" -Name "Media" -ItemType directory -ErrorAction SilentlyContinue
Expand-Archive -Path $workdir\utils\Media${var}.zip -DestinationPath $env:SYSTEMDRIVE\Windows\Media
Copy-Item -Path $workdir\utils\* -Include Media*.zip -Destination $env:SYSTEMDRIVE\Windows
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Custom system sounds have been installed"
Start-Sleep -Seconds 3
