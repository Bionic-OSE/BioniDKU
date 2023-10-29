# Music picker module, part of the main menu - Still in the works

#if ($confuleb -eq 0) {& $coredir\music\musicheck.ps1}
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditingSub" -Value 5 -Type DWord -Force
Show-Branding clear
Show-WelcomeText

function Select-DisenabledCol($regvalue) {
	$regreturns = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music").$regvalue
	if ($regreturns -eq 1) {
		if (Check-AtLeastOneCol) {
			Show-Branding clear
			Write-Host -ForegroundColor Red "At least one collection must be enabled. If you want to disable all, use option 5 in the Configuration menu."
			Write-Host -ForegroundColor White "Press Enter to continue."
			Read-Host
			exit
		}
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music" -Name $regvalue -Value 0 -Type DWord -Force
	} else {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music" -Name $regvalue -Value 1 -Type DWord -Force
	}
}
function Check-AtLeastOneCol {
	$values = $touhou, $genshin, $deltarune, $undertale, $featured
	$oneCount = ($values -eq 1).Count; $zeroCount = ($values -eq 0).Count
	if ($oneCount -eq 1 -and $zeroCount -eq ($values.Count - 1)) {return $true} else {return $false}
}

$global:touhou    = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music").1
$global:genshin   = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music").2
$global:deltarune = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music").3
$global:undertale = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music").4
$global:featured  = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music").5

Write-Host -ForegroundColor Yellow "`r`nOne of the main selling points of BioniDKU is its HUGE library of music, with over 60+ songs. Customize your selection by selecting your desired collections."
Write-Host -ForegroundColor Gray "The selected collections will be downloaded in Download mode, and all songs within them will be shuffled."
Write-Host -ForegroundColor Gray "(FYI, categories from 1 to 4 are game sound tracks. You can look up on the internet about those games. As for category 5, it features works from independent composers or artists groups that I hand-picked.)"
Write-Host -ForegroundColor White "1. Touhou OSTs" -n;         Show-Disenabled $touhou   
Write-Host -ForegroundColor White "2. Genshin Impact OSTs" -n; Show-Disenabled $genshin  
Write-Host -ForegroundColor White "3. Deltarune OSTs" -n;      Show-Disenabled $deltarune
Write-Host -ForegroundColor White "4. Undertale OSTs" -n;      Show-Disenabled $undertale
Write-Host -ForegroundColor White "5. Featured Artists" -n;    Show-Disenabled $featured 
Write-Host -ForegroundColor White "Select 0 to return to the previous menu."
Write-Host " "
Write-Host "> " -n ; $colsel = Read-Host

switch ($colsel) {
	{$_ -like "1"} {Select-DisenabledCol 1 ; exit}
	{$_ -like "2"} {Select-DisenabledCol 2 ; exit}
	{$_ -like "3"} {Select-DisenabledCol 3 ; exit}
	{$_ -like "4"} {Select-DisenabledCol 4 ; exit}
	{$_ -like "5"} {Select-DisenabledCol 5 ; exit}
	{$_ -like "0"} {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigEditingSub" -Value 0 -Type DWord -Force
		exit
	}
}
