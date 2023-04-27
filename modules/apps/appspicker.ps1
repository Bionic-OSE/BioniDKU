# Apps picker module, part of the main menu

Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditingSub" -Value 7 -Type DWord -Force
Show-Branding clear

function Select-DisenabledApp($regvalue) {
	$regreturns = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").$regvalue
	if ($regreturns -eq 1) {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps" -Name $regvalue -Value 0 -Type DWord -Force
	} else {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps" -Name $regvalue -Value 1 -Type DWord -Force
	}
}

Write-Host -ForegroundColor Magenta "Welcome to BioniDKU!"
$WinaeroTweaker = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").WinaeroTweaker
$OpenShell      = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").OpenShell
$TClock         = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").TClock
$Firefox        = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").Firefox
$NPP            = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").NPP
$ShareX         = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").ShareX
$PDN            = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").PDN
$ClassicTM      = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").ClassicTM
$DesktopInfo    = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").DesktopInfo
Write-Host " "
Write-Host -ForegroundColor Yellow "The following apps will be downloaded and installed. Select the ones that suits your need."
Write-Host -ForegroundColor White "1. Winaero Tweaker" -n;                                     Show-Disenabled $WinaeroTweaker
Write-Host -ForegroundColor White "2. Open-Shell" -n; Write-Host " (4.4.170)" -n;              Show-Disenabled $OpenShell     
Write-Host -ForegroundColor White "3. T-Clock" -n; Write-Host " (2.4.4)" -n;                   Show-Disenabled $TClock        
Write-Host -ForegroundColor White "4. Mozilla Firefox ESR" -n;                                 Show-Disenabled $Firefox       
Write-Host -ForegroundColor White "5. Notepad++" -n; Write-Host " (8.5)" -n;                   Show-Disenabled $NPP           
Write-Host -ForegroundColor White "6. ShareX (13.1.0)" -n;                                     Show-Disenabled $ShareX        
Write-Host -ForegroundColor White "7. Paint.NET (4.0.19)" -n;                                  Show-Disenabled $PDN           
Write-Host -ForegroundColor White "8. Classic Task Manager & Classic System Configuration" -n; Show-Disenabled $ClassicTM     
Write-Host -ForegroundColor White "9. DesktopInfo (2.10.2, with custom configuration)" -n;     Show-Disenabled $DesktopInfo   
Write-Host -ForegroundColor White "Select 0 to return to the previous menu."
Write-Host " "
Write-Host "Your selection: " -n ; $appsel = Read-Host

switch ($appsel) {
	{$_ -like "1"} {Select-DisenabledApp WinaeroTweaker; exit}
	{$_ -like "2"} {Select-DisenabledApp OpenShell; exit}
	{$_ -like "3"} {Select-DisenabledApp TClock; exit}
	{$_ -like "4"} {Select-DisenabledApp Firefox; exit}
	{$_ -like "5"} {Select-DisenabledApp NPP; exit}
	{$_ -like "6"} {Select-DisenabledApp ShareX; exit}
	{$_ -like "7"} {Select-DisenabledApp PDN; exit}
	{$_ -like "8"} {Select-DisenabledApp ClassicTM; exit}
	{$_ -like "9"} {Select-DisenabledApp DesktopInfo; exit}
	{$_ -like "0"} {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditingSub" -Value 0 -Type DWord -Force
		exit
	}
}