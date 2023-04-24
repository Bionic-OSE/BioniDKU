# Hikaru-chan - Used during BioniDKU script execution - (c) Bionic Butter

function Start-HikaruChan($mode) {
	if ($mode -eq 0) {
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value 'explorer.exe' -Type String
		Start-Process $env:SYSTEMDRIVE\Windows\explorer.exe 
		Start-Process "$coredir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $coredir\ambient\DomainAmbient.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
		Start-Sleep -Seconds 5
	} elseif ($mode -eq 1) {
		$manmode = Test-Path -Path "$coredir\boot\launcherman.bat" -PathType Leaf
		if ($manmode -eq $true) {
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "$env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe /run /exefilename $env:SYSTEMDRIVE\Windows\System32\cmd.exe /commandline `"/c $coredir\boot\launcherman.bat`"" -Type String
		}
		else {
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "$env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe /run /exefilename `"$coredir\boot\launcher.exe`"" -Type String
		}
	}
}
$hkm = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMode; Start-HikaruChan $hkm
