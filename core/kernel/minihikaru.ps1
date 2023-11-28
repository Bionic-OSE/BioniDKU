# MiniHikaru functions hive - Used during BioniDKU script execution - (c) Bionic Butter

function Set-HikaruChan($runonce) {
	switch ($runonce) {
		"runonce" {
			$launchkey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
			$launchval = "BioniDKU Completion Screen"
		}
		default {
			$launchkey = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
			$launchval = "Shell"
		}
	}

	$advancedpfx = "$env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe /run /waitprocess 0 /exefilename"
	if (Test-Path -Path "$coredir\7boot\launcherman.bat" -PathType Leaf) {
		Set-ItemProperty -Path $launchkey -Name $launchval -Value "$advancedpfx $env:SYSTEMDRIVE\Windows\System32\cmd.exe /commandline `"/c $coredir\7boot\launcherman.bat`"" -Type String -Force
	} else {
		Set-ItemProperty -Path $launchkey -Name $launchval -Value "$advancedpfx `"$coredir\7boot\launcher.exe`"" -Type String -Force
	}
}

function Start-HikaruShell {
	Start-Process $env:SYSTEMDRIVE\Windows\explorer.exe 
	Start-Sleep -Seconds 5
}
