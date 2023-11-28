# BioniDKU OS information grabber

. $workdir\modules\lib\Get-Edition.ps1
function Write-OSInfo {
	Write-Host -ForegroundColor White "You're running Windows $editiontype $editiond, OS build ${build}.${ubr}"
}
$global:build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$global:ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
