# BioniDKU System Apps disabler module

$global:workdir = Split-Path(Split-Path "$PSScriptRoot")
$global:datadir = "$workdir\data"
Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Logging.psm1
Import-Module -DisableNameChecking $workdir\modules\lib\Dynamic-Destructor.psm1
$keepedgechromium = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").EdgeNoMercy
$keepsearch = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SearchNoMercy

$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | System Apps disabler module"
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "System Apps disabler module" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}
Start-Logging NormalMode_RemoveSysApps
Show-Branding

Write-Host "Disabling some System Apps" -ForegroundColor Cyan -BackgroundColor DarkGray
Start-Sleep -Seconds 3

function Rename-AppsFolder($ogn,$nwn) {
	Rename-Item -Path $ogn -NewName $nwn -Force
}
function Disable-Executable($exepath) {
	Move-Item -Path $exepath -Destination "$exepath.DISABLED" -Force
	Copy-Item -Path $workdir\utils\AppNullifier.exe -Destination $exepath -Force
}
function Stop-Processes {
	Stop-Process -Force -ErrorAction SilentlyContinue -Name ApplicationFrameHost.exe
	Stop-Process -Force -ErrorAction SilentlyContinue -Name msedge.exe
	Stop-Process -Force -ErrorAction SilentlyContinue -Name msedgewebview.exe
	Stop-Process -Force -ErrorAction SilentlyContinue -Name MicrosoftEdgeUpdate.exe
	Stop-Process -Force -ErrorAction SilentlyContinue -Name MicrosoftEdgeCP.exe
	Stop-Process -Force -ErrorAction SilentlyContinue -Name MicrosoftEdge.exe
	Stop-Process -Force -ErrorAction SilentlyContinue -Name LockApp.exe
	Stop-Process -Force -ErrorAction SilentlyContinue -Name SearchHost.exe
	Stop-Process -Force -ErrorAction SilentlyContinue -Name StartMenuExperienceHost.exe
}

# Microsoft Edge Legacy and other system UWPs
$sappfldr = "$env:SYSTEMDRIVE\Windows\SystemApps"
$edgexaml = "Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
$lockxaml = "Microsoft.LockApp_cw5n1h2txyewy"
$srchxaml = "Microsoft.Windows.Search_cw5n1h2txyewy"
$startapp = "Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy"
$sappfami = $edgexaml, $lockxaml, $srchxaml, $startapp

foreach ($sapp in $sappfami) {
	#Stop-Processes
	$sapppath = "$sappfldr\$sapp"
	if (Test-Path -Path $sapppath) {
		Grant-Ownership D $sapppath
		#Rename-AppsFolder $sapppath "$sapp.DISABLED"
	}
}

$edgexaml = Test-Path "$sappfldr\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
$lockxaml = Test-Path "$sappfldr\Microsoft.LockApp_cw5n1h2txyewy"
$srchxaml = Test-Path "$sappfldr\Microsoft.Windows.Search_cw5n1h2txyewy"
$startapp = Test-Path "$sappfldr\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy"
taskkill /f /im ApplicationFrameHost.exe
taskkill /f /im explorer.exe
Start-Sleep -Seconds 2
switch ($true) {
	$edgexaml {
		taskkill /f /im MicrosoftEdgeCP.exe
		taskkill /f /im MicrosoftEdge.exe
		Rename-AppsFolder "$sappfldr\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" "Microsoft.MicrosoftEdge_8wekyb3d8bbwe.DISABLED"
	}
	$lockxaml {
		taskkill /f /im LockApp.exe
		Rename-AppsFolder "$sappfldr\Microsoft.LockApp_cw5n1h2txyewy" "Microsoft.LockApp_cw5n1h2txyewy.DISABLED"
	}
	{$srchxaml -and $keepsearch -ne 1} {
		taskkill /f /im SearchHost.exe
		Rename-AppsFolder "$sappfldr\Microsoft.Windows.Search_cw5n1h2txyewy" "Microsoft.Windows.Search_cw5n1h2txyewy.DISABLED"
	}
	$startapp {
		taskkill /f /im StartMenuExperienceHost.exe
		Rename-AppsFolder "$sappfldr\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy" "Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy.DISABLED"
	}
}

Start-Sleep -Seconds 2
Start-Process explorer.exe
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "The Apps should be disabled now"
Start-Sleep -Seconds 2
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "SystemAppsRemoved" -Value 1 -Type DWord -Force
Start-Sleep -Seconds 1
exit
