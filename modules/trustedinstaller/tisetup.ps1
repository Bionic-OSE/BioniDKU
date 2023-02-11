Write-Host "Initializing TrustedInstaller" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)

$tireg = Test-Path -Path 'HKCU:\SOFTWARE\AutoIDKU\TrustedInstaller'
if ($tireg -eq $false) {
	Write-Host -ForegroundColor Cyan "Setting up environment for TI"
	New-Item -Path 'HKLM:\SOFTWARE' -Name AutoIDKU
	New-Item -Path 'HKLM:\SOFTWARE\AutoIDKU' -Name TrustedInstaller
}

switch ($true) {
	
	$removesystemapps {
		Set-ItemProperty -Path "HKLM:\Software\AutoIDKU\TrustedInstaller" -Name "RemoveSystemApps" -Value 1 -Type DWord -Force
	}
	
	$sltoshutdownwall {
		Set-ItemProperty -Path "HKLM:\Software\AutoIDKU\TrustedInstaller" -Name "SlideToShutDownWallpaper" -Value 1 -Type DWord -Force
	}
	
}
Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe -Wait -ArgumentList "/run /exefilename $env:SYSTEMDRIVE\Windows\System32\WindowsPowerShell\v1.0\powershell.exe /waitprocess 1 /runas 8 /commandline `"-Command $PSScriptRoot\tinitialize.ps1`""

Write-Host -ForegroundColor Cyan "Dropping into TI"
Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe -Wait -ArgumentList "/run /exefilename $env:SYSTEMDRIVE\Windows\System32\WindowsPowerShell\v1.0\powershell.exe /waitprocess 1 /runas 8 /commandline `"-Command $PSScriptRoot\tiworker.ps1`""
