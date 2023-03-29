$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Music fetcher module"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "Music fetcher module" -ForegroundColor Blue -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
$mexists = Test-Path -Path "$PSScriptRoot\normal"
if ($mexists -eq $true) {exit}

Show-Branding
Import-Module BitsTransfer

for ($c = 1; $c -le 5; $c++) {
	$cv = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music").$c
	if ($cv -eq 1) {
		for ($n = 1; $n -le 9; $n++) {
			Write-Host "Transfering category $c..." -ForegroundColor White
			Start-BitsTransfer -Source "https://github.com/Bionic-OSE/BioniDKU-music/raw/music/normal$c.7z.00$n" -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		}
		Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "x $PSScriptRoot\normal$c.7z.001 -o$PSScriptRoot\normal"
	}
}



Write-Host " "
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Extraction complete." -n; Write-Host " (Ignore the warnings tho, the files should be fine.)"
Write-Host -ForegroundColor Yellow "Some of the songs featured in this (nearly infinite) collection might be copyrighted. If you are planning to record and upload this run to public platforms, please beware of that. You can view this collection in $PSScriptRoot\normal"
Write-Host -ForegroundColor Yellow "Continuing in 10 seconds" -n; Write-Host " (or you can skip by pressing Ctrl+C)"
Start-Sleep -Seconds 10
