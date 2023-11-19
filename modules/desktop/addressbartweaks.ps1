Param(
	[Parameter(Mandatory=$True,Position=0)]
	[int32]$action
)

switch ($action) {
	1 {
		$vlblds = 18363,19041,19042,19043,19044,19045
		if (-not $vlblds.Contains($build)) {exit} elseif ($build -eq 19045 -and $ubr -ge 3754) {exit}
		if ($build -eq 18363) {$brc = "Mn"} else {$brc = "Vb"}
		. $workdir\modules\lib\DestructionsBlessing.ps1
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Thinning the Explorer address bar"
		taskkill /f /im explorer.exe; Start-Sleep -Seconds 2
		Copy-Item -Path $env:SYSTEMDRIVE\Windows\System32\ExplorerFrame.dll -Destination $env:SYSTEMDRIVE\Bionic\Hikaru\ExplorerFrame.dll.QUARANTINE
		Remove-SystemFile F $env:SYSTEMDRIVE\Windows\System32\ExplorerFrame.dll
		Expand-Archive -Path $datadir\utils\AddressBarThinner2.zip -DestinationPath $datadir\utils\AddressBarThinner2
		Copy-Item -Path $datadir\utils\AddressBarThinner2\$brc\ExplorerFrame.dll -Destination $env:SYSTEMDRIVE\Windows\System32\ExplorerFrame.dll
		Start-Process explorer.exe
	}
	2 {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling the Explorer address bar"
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "AddressBarRemover2" -Value "$env:SYSTEMDRIVE\Bionic\Hikaru\AddressBarRemover2.exe" -Type String -Force
	}
}
