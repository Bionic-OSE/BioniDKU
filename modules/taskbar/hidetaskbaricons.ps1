Write-Host "Hiding Taskbar Icons" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)

$explorerdir = (Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer')
if ($explorerdir -eq $false) {New-Item -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Explorer' -Force}

Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTaskViewButton' -Value 0 -Type DWord -Force
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchBoxTaskbarMode' -Value 0 -Type DWord -Force
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'DisableNotificationCenter' -Value 1 -Type DWord -Force

if ($build -ge 16299) {
    Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name 'PeopleBand' -Value 0 -Type DWord -Force
    Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'PeopleBand' -Value 0 -Type DWord -Force
}

if ($build -ge 18362) {
    $explorerdir = (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer')
    if ($explorerdir -eq $true) {New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies' -Name 'Explorer' -Force}
}

$feeder = Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds'

if ($build -ge 18363) {
    Stop-Process -Name "explorer"
    Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'HideSCAMeetNow' -Value 1 -Type DWord -Force
	if ($feeder) {
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds' -Name 'ShellFeedsTaskbarViewMode' -Value 2 -Type DWord -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds' -Name 'IsFeedsAvailable' -Value 0 -Type DWord -Force
	}
    Start-Process explorer
}
