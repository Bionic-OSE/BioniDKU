# MiniHikaru functions hive - Used during BioniDKU script execution - (c) Bionic Butter

function Set-HikaruChan {
	$manmode = Test-Path -Path "$coredir\7boot\launcherman.bat" -PathType Leaf
	if ($manmode -eq $true) {
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "$env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe /run /waitprocess 0 /exefilename $env:SYSTEMDRIVE\Windows\System32\cmd.exe /commandline `"/c $coredir\7boot\launcherman.bat`"" -Type String
	}
	else {
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "$env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe /run /waitprocess 0 /exefilename `"$coredir\7boot\launcher.exe`"" -Type String
	}
}

function Start-HikaruShell {
	Start-Process $env:SYSTEMDRIVE\Windows\explorer.exe 
	Start-Process "$datadir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainAmbient.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
	Start-Sleep -Seconds 5
}
