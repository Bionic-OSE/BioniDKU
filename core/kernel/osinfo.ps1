# BioniDKU OS information grabber - (c) Bionic Butter

Import-Module -DisableNameChecking $workdir\modules\lib\Get-Edition.psm1
$global:edition, $global:editiontype, $global:editiond = Get-Edition
function Write-OSInfo {
	Write-Host -ForegroundColor White "You're running Windows $editiontype $editiond, OS build ${build}.${ubr}"
}
$global:build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$global:ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
