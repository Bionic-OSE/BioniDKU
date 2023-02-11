$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | TrustedInstaller mode"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "TrustedInstaller mode" -ForegroundColor Yellow -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
Show-Branding
$workdir = "$PSScriptRoot\..\.."

$removesystemapps = (Get-ItemProperty -Path "HKLM:\Software\AutoIDKU\TrustedInstaller").RemoveSystemApps
$sltoshutdownwall = (Get-ItemProperty -Path "HKLM:\Software\AutoIDKU\TrustedInstaller").SlideToShutDownWallpaper

switch (1) {
	
	$removesystemapps {
		& $PSScriptRoot\removesystemapps.ps1
	}
	
	$sltoshutdownwall {
		& $PSScriptRoot\slidetoshutdownwall.ps1
	}
	
}
