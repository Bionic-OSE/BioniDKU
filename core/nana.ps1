Clear-Host
Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta
Write-Host "Starting up..." -ForegroundColor Magenta -BackgroundColor Gray
Write-Host " "

$pwsh7 = "https://github.com/PowerShell/PowerShell/releases/download/v7.3.0/PowerShell-7.3.0-win-x64.msi"
# Create Registry Folder
$autoidku = Test-Path -Path 'HKCU:\SOFTWARE\AutoIDKU'
if ($autoidku -eq $false) {
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting up environment"
	New-Item -Path 'HKCU:\SOFTWARE' -Name AutoIDKU
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "BootStrapped" -Value 0 -Type DWord -Force
	}

# Is the bootstrap process already completed?
$booted = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").BootStrapped
if ($booted -eq 1) {exit}

# Find the build, then decide what PowerShell version to run on
# Your version must be between 10240 and 19045. If it is not, not supported.
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Checking your PC"
$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
switch ($build) {
    {$_ -ge 10240 -and $_ -le 19045} {Write-Host "Supported version of Windows 10 detected" -ForegroundColor Green -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)}
    default {
        Write-Host "You're not running a supported version of Windows for this script. Press Enter to exit." -ForegroundColor Red
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 1 -Type DWord -Force
        Read-Host
        exit
    }
}
Write-Host "You're running Windows 10"$build"."$ubr

# Get the utilities package
Start-Process powershell -Wait -ArgumentList "-Command $PSScriptRoot\..\utils\utilsg.ps1" -WorkingDirectory $PSScriptRoot\..\utils

# Install PowerShell 7 (on 5 this will only be used for the music player)
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Getting dependencies ready"
Import-Module BitsTransfer
Start-BitsTransfer -Source $pwsh7 -Destination $PSScriptRoot\core7.msi -RetryInterval 60
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Getting ready"
Start-Process msiexec -Wait -ArgumentList "/package $PSScriptRoot\core7.msi /quiet ADD_PATH=1"

if ($build -le 10586) {
	Write-Host " "
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Pwsh" -Value 5 -Type DWord -Force
}
if ($build -ge 14393) {
	Write-Host " "
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Pwsh" -Value 7 -Type DWord -Force
}
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "BootStrapped" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ConfigSet" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 0 -Type DWord -Force
exit