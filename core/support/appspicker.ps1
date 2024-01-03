# Apps picker module, part of the main menu

$apps = "\Apps"

while ($true) {
	Show-Branding clear
	Write-Host -ForegroundColor Yellow "The following apps will be downloaded and installed. Select the ones that suits your need."
	Write-Host -ForegroundColor Gray "Version numbers listed here are fixed and will not change in the future. Otherwise, you will get the latest version`r`nof the apps."
	Write-Host -ForegroundColor White "1. Winaero Tweaker" -n;                             Show-Disenabled WinaeroTweaker $apps
	Write-Host -ForegroundColor White "2. Open-Shell" -n;                                  Show-Disenabled OpenShell $apps
	Write-Host -ForegroundColor White "3. T-Clock" -n; Write-Host " (2.4.4)" -n;           Show-Disenabled TClock $apps
	Write-Host -ForegroundColor White "4. Mozilla Firefox ESR" -n;                         Show-Disenabled Firefox $apps
	Write-Host -ForegroundColor White "5. Notepad++" -n;                                   Show-Disenabled NPP $apps
	Write-Host -ForegroundColor White "6. ShareX" -n; Write-Host " (13.1.0)" -n;           Show-Disenabled ShareX $apps
	Write-Host -ForegroundColor White "7. Paint.NET" -n; Write-Host " (4.0.19)" -n;        Show-Disenabled PDN $apps
	Write-Host -ForegroundColor White "8. Classic Task Manager & System Configuration" -n; Show-Disenabled ClassicTM $apps
	Write-Host -ForegroundColor White "9. DesktopInfo" -n; Write-Host " (2.10.2)" -n;      Show-Disenabled DesktopInfo $apps
	Write-Host -ForegroundColor White "X. VLC" -n;                                         Show-Disenabled VLC $apps
	Write-Host -ForegroundColor White "Select 0 to return to the previous menu."
	Write-Host " "
	Write-Host "> " -n ; $appsel = Read-Host
	
	switch ($appsel) {
		"1" {Select-Disenabled WinaeroTweaker $apps}
		"2" {Select-Disenabled OpenShell $apps}
		"3" {Select-Disenabled TClock $apps}
		"4" {Select-Disenabled Firefox $apps}
		"5" {Select-Disenabled NPP $apps}
		"6" {Select-Disenabled ShareX $apps}
		"7" {Select-Disenabled PDN $apps}
		"8" {Select-Disenabled ClassicTM $apps}
		"9" {Select-Disenabled DesktopInfo $apps}
		"X" {Select-Disenabled VLC $apps}
		"0" {exit}
	}
}
