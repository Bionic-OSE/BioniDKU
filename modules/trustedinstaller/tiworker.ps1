$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter and Sunryze | TrustedInstaller mode"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "TrustedInstaller mode" -ForegroundColor Yellow -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
Show-Branding

$removesystemapps = (Get-ItemProperty -Path "HKLM:\Software\AutoIDKU\TrustedInstaller").RemoveSystemApps
$removewinold = (Get-ItemProperty -Path "HKLM:\Software\AutoIDKU\TrustedInstaller").RemoveWindowsOld

switch (1) {
	
	$removesystemapps {
		& $PSScriptRoot\removesystemapps.ps1
	}
	
	$removewinold {
		& $PSScriptRoot\removewinold.ps1
	}
	
}
