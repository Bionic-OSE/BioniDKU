# This module gets the core components required for the script to start properly, part of Nana the bootloader

Param(
  [Parameter(Mandatory=$True,Position=0)]
  [int32]$action
)
function Start-DownloadLoop($link,$destfile,$name,$descr) {
	while ($true) {
		Start-BitsTransfer -DisplayName "$name" -Description "$descr" -Source $link -Destination $datadir\dls -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		if (Test-Path -Path "$datadir\dls\$destfile" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor Black -BackgroundColor Red "Ehhhhhhh"
			Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
			Start-Sleep -Seconds 1
		}
	}
}
Import-Module BitsTransfer

switch ($action) {
	0 {
		$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Getting critical components... | DO NOT CLOSE THIS WINDOW OR DISCONNECT INTERNET"
		Clear-Host
		Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
		Write-Host "Getting critical components..." -ForegroundColor Blue -BackgroundColor Gray
		Write-Host " "
		
		$global:workdir = Split-Path(Split-Path "$PSScriptRoot")
		$global:coredir = Split-Path "$PSScriptRoot"
		$global:datadir = "$workdir\data"
		
		Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-utils/raw/utils/active/ambient.zip" "ambient.zip" "Getting ambient sounds package" " "
		Expand-Archive -Path $datadir\dls\ambient.zip -DestinationPath $datadir\ambient
	}
	1 {
		$hexists = Test-Path -Path "$datadir\dls\sakuraground.7z" -PathType Leaf
		if ($hexists) {exit}

		$hikalink = "download/400_b5" # Stable "latest/download"
		
		Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/${hikalink}/Scripts.7z" "Scripts.7z" "Getting Hikaru-chan" "Downloading soft (scripts) layer"
		Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/${hikalink}/Executables.7z" "Executables.7z" "Getting Hikaru-chan" "Downloading hard (executables) layer"
		Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/${hikalink}/Servicer.7z" "Servicer.7z" "Getting Hikaru-chan" "Downloading servicing layer"
		Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/${hikalink}/Hikarinfo.ps1" "Hikarinfo.ps1" "Getting Hikaru-chan" "Downloading release information file"
		Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-utils/raw/utils/active/background.png" "background.png" "Getting desktop background image" " "
		Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU-utils/raw/utils/active/sakuraground.png" "sakuraground.png" "Getting desktop background image" " "
		
		if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic") -eq $false) {New-Item -Path "$env:SYSTEMDRIVE\" -Name Bionic -itemType Directory | Out-Null}
		Start-Process $coredir\7z\7za.exe -Wait -NoNewWindow -ArgumentList "x $datadir\dls\Scripts.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic"
		Start-Process $coredir\7z\7za.exe -Wait -NoNewWindow -ArgumentList "x $datadir\dls\Executables.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic"
		Start-Process $coredir\7z\7za.exe -Wait -NoNewWindow -ArgumentList "x $datadir\dls\Servicer.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic"
		Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikarefreshinfo.ps1 -O HikarefreshinFOLD.ps1" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikarefresh" 
		Show-WindowTitle 1 "Getting ready" noclose
		. $datadir\dls\Hikarinfo.ps1
		New-Item -Path 'HKCU:\SOFTWARE' -Name Hikaru-chan
		Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "Version" -Value "22110.$version" -Force
		Move-Item -Path "$datadir\dls\Hikarinfo.ps1" -Destination "$env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarinFOLD.ps1"
	}
}
