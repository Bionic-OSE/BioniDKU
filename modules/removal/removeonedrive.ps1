Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing OneDrive"
Import-Module -DisableNameChecking $workdir\modules\lib\New-FolderForced.psm1
Import-Module -DisableNameChecking $workdir\modules\lib\Take-Own.psm1

Write-Host -ForegroundColor Cyan "Stopping OneDrive processes and Explorer"
taskkill.exe /F /IM "OneDrive.exe"
taskkill.exe /F /IM "OneDriveSetup.exe"
taskkill.exe /F /IM "explorer.exe"

# Give them 3 seconds
Start-Sleep -Seconds 3

Write-Host -ForegroundColor Cyan "Attempting to uninstall OneDrive"
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
	Start-Process "$env:systemroot\System32\OneDriveSetup.exe" -Wait -ArgumentList "/uninstall"
} elseif (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
	Start-Process "$env:systemroot\SysWOW64\OneDriveSetup.exe" -Wait -ArgumentList "/uninstall"
}

# Give it another 3 seconds
Start-Sleep -Seconds 3

Write-Host -ForegroundColor Cyan "Removing leftovers"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:systemdrive\OneDriveTemp"
# Check if directory is empty before removing:
If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
	Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
}

Write-Host -ForegroundColor Cyan "Disallowing OneDrive system-wide"
New-FolderForced -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" "DisableFileSyncNGSC" 1

Write-Host -ForegroundColor Cyan "Removing OneDrive folder from Explorer navigation pane"
if (-not (Test-Path HKCR:\)) {New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"}
mkdir -Force "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
Set-ItemProperty -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
mkdir -Force "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
Set-ItemProperty -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
Remove-PSDrive "HKCR"

# Thank you Matthew Israelsson
Write-Host -ForegroundColor Cyan "Removing run hook for new users"
reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
reg unload "hku\Default"

Write-Host -ForegroundColor Cyan "Removing Start Menu entry"
Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

Write-Host -ForegroundColor Cyan "Removing scheduled task (you may see an error and that's fine)"
Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false

Write-Host -ForegroundColor White "Restarting Explorer"
Start-Process "explorer.exe"

Write-Host -ForegroundColor Cyan "Waiting for Explorer to complete loading"
Write-Host -ForegroundColor Yellow "If an error pops up saying OneDrive has failed to uninstall, it's its bug. OneDrive should be cleaned from the system now (at least on the disk)."
Start-Sleep -Seconds 10
taskkill.exe /F /IM "OneDriveSetup.exe"
