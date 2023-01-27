# Hikaru-chan by Bionic Butter - Customized for BioniDKU

function Start-HikaruChan($mode) {
	if ($mode -eq 0) {
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value 'explorer.exe' -Type String
		Start-Process $env:SYSTEMDRIVE\Windows\explorer.exe 
		Start-Process "$PSScriptRoot\ambient\FFPlay.exe" -NoNewWindow -ArgumentList "-i $PSScriptRoot\ambient\DomainAmbient.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
		Start-Sleep -Seconds 5
	} elseif ($mode -eq 1) {
		$manmode = Test-Path -Path "$PSScriptRoot\launcherman.bat" -PathType Leaf
		if ($manmode -eq $true) {
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "$env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe /run /exefilename $env:SYSTEMDRIVE\Windows\System32\cmd.exe /commandline `"/c $PSScriptRoot\launcherman.bat`"" -Type String
		}
		else {
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "$env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe /run /exefilename `"$PSScriptRoot\launcher.exe`"" -Type String
		}
	}
}
$hkm = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMode; Start-HikaruChan $hkm
