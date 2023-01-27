Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Configuring Hikaru-chan" -n; Write-Host ([char]0xA0)

reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\ShellHikaru.reg"
$hkreg = Test-Path -Path 'HKCU:\SOFTWARE\Hikaru-chan'
if ($hkreg -eq $false) {
	New-Item -Path 'HKCU:\SOFTWARE' -Name Hikaru-chan
}
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UseOSSEStartupSound" -Value 0 -Type DWord -Force

"
@echo off
rem ####### Hikaru-chan by Bionic Butter #######
start $env:SYSTEMDRIVE\Windows\System32\systeminfo.exe
"| Out-File -FilePath "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarun.bat" -Encoding ascii

