Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Configuring Hikaru-chan"

$ds = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").DarkSakura
if ($ds -eq 1) {$var = 3} else {$var = 1}
reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\ShellHikaru.reg"
$hkreg = Test-Path -Path 'HKCU:\SOFTWARE\Hikaru-chan'
if ($hkreg -eq $false) {
	New-Item -Path 'HKCU:\SOFTWARE' -Name Hikaru-chan
}
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "ProductName" -Value "BioniDKU" -Type String -Force
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "StartupSoundVariant" -Value $var -Type DWord -Force
Show-WindowTitle noclose

# Hikarun on-demand customization section
if ($hidetaskbaricons -and $build -ge 18362) {
	$hkrdockico = 
@"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAMeetNow /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v IsFeedsAvailable /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f
"@
} else {$hkrdockico = ""}

# Also from here, reenable UAC if it's a GA build
if ($keepuac -and $ngawarn -ne 1) {Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name EnableLUA -Value 1 -Force}

# Write the customized values to the on-demand batch file
@"
@echo off
rem ####### Hikaru-chan by Bionic Butter #######

$hkrdockico
"@ | Out-File -FilePath "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarun.bat" -Encoding ascii

# Install HikaruQM and pre-apply system restrictions (set restrictions but at disabled state)
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$hkQML = "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe"
$hkQMLS = "$env:AppData\Microsoft\Windows\Start Menu\Programs\BioniDKU Quick Menu Tray.lnk"
$hkQMLSh = $WscriptObj.CreateShortcut($hkQMLS)
$hkQMLSh.TargetPath = $hkQML
$hkQMLSh.Save()
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BioniDKU Quick Menu Tray" -Value "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe" -Type String -Force

Copy-Item -Path $env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe -Destination "$env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationFrameHost.QUARANTINE"
Copy-Item -Path $coredir\7z\7za.exe -Destination "$env:SYSTEMDRIVE\Windows\7za.exe"
Copy-Item -Path $coredir\7z\7zxa.dll -Destination "$env:SYSTEMDRIVE\Windows\7zxa.dll"
taskkill /f /im ApplicationFrameHost.exe
takeown /f "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe"
icacls "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe" /grant Administrators:F

if ($build -eq 10586) {mofcomp C:\Windows\System32\wbem\SchedProv.mof}
$hkF5action = New-ScheduledTaskAction -Execute "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefresh.exe"
$hkF5trigger = @(
	$(New-ScheduledTaskTrigger -AtLogon),
	$(New-ScheduledTaskTrigger -Daily -DaysInterval 1 -At 8am)
)
$hkF5settings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew
$hkF5 = New-ScheduledTask -Action $hkF5action -Trigger $hkF5trigger -Settings $hkF5settings
Register-ScheduledTask 'BioniDKU Quick Menu Update Checker' -InputObject $hkF5

# This line is here for Hikaru beta. Remove it on final please.
Disable-ScheduledTask 'BioniDKU Quick Menu Update Checker'

# With the new UAC-enabled system, permission issues became a problem. The chunk of code below is to address all of that.
$hkbpstname = 'BioniDKU Windows Build String Modifier'
$hkbpaction = New-ScheduledTaskAction -Execute "%SystemDrive%\Bionic\Hikaru\HikaruBuildMod.exe"
$hkbprincipal = New-ScheduledTaskPrincipal -UserID "$env:USERNAME" -LogonType Interactive -RunLevel Highest
$hkbpsettings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew
$hkbp = New-ScheduledTask -Action $hkbpaction -Principal $hkbprincipal -Settings $hkbpsettings
Register-ScheduledTask $hkbpstname -InputObject $hkbp
$hklcstname = 'BioniDKU UWP Lockdown Controller'
$hklcaction = New-ScheduledTaskAction -Execute "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument "-Command `"& %SystemDrive%\Bionic\Hikaru\ApplicationControlHost.ps1`""
$hklc = New-ScheduledTask -Action $hklcaction -Principal $hkbprincipal -Settings $hkbpsettings
Register-ScheduledTask $hklcstname -InputObject $hklc

$Scheduler = New-Object -ComObject "Schedule.Service"; $Scheduler.Connect() # From: https://www.osdeploy.com/blog/2021/scheduled-tasks/task-permissions
$hket = @()
$hket += $hkbpstname; $hket += $hklcstname
foreach ($hketname in $hket) {
	$GetTask = $Scheduler.GetFolder('\').GetTask($hketname)
	$GetSecurityDescriptor = $GetTask.GetSecurityDescriptor(0xF)
	if ($GetSecurityDescriptor -notmatch 'A;;0x1200a9;;;AU') {
		$GetSecurityDescriptor = $GetSecurityDescriptor + '(A;;GRGX;;;AU)'
		$GetTask.SetSecurityDescriptor($GetSecurityDescriptor, 0)
	}
}
$pacl = Get-Acl "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$pule = New-Object System.Security.AccessControl.RegistryAccessRule ("$env:USERNAME","FullControl",@("ObjectInherit","ContainerInherit"),"None","Allow")
$pacl.SetAccessRule($pule)
$pacl | Set-Acl -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"

# Now we actually preapply the restrictions.
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name DisallowRun -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTrayContextMenu -Value 0 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData" -Name AllowLockScreen -Value 0 -Type DWord
reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestrict.reg"
$cmd = Test-Path -Path "HKCU:\Software\Microsoft\Command Processor"
if ($cmd -eq $false) {
	New-Item -Path "HKCU:\Software\Microsoft" -Name "Command Processor"
}
