Write-Host "Creating desktop shortcuts" -ForegroundColor Cyan -BackgroundColor DarkGray

New-Item -Path $env:USERPROFILE -Name DL -itemType Directory

$WScriptObj = New-Object -ComObject ("WScript.Shell")

$SourceFilePath1 = "$env:USERPROFILE\Documents"
$SourceFilePath2 = "$env:USERPROFILE\DL"
$SourceFilePath3 = "$env:USERPROFILE\Pictures"
$SourceFilePath4 = "$env:USERPROFILE\Music"
$SourceFilePath5 = "$env:USERPROFILE\Videos"

$ShortcutPath1 = "$env:USERPROFILE\Desktop\Documents.lnk"
$ShortcutPath2 = "$env:USERPROFILE\Desktop\Downloads.lnk"
$ShortcutPath3 = "$env:USERPROFILE\Desktop\Pictures.lnk"
$ShortcutPath4 = "$env:USERPROFILE\Desktop\Music.lnk"
$ShortcutPath5 = "$env:USERPROFILE\Desktop\Videos.lnk"

$shortcut1 = $WscriptObj.CreateShortcut($ShortcutPath1)
$shortcut2 = $WscriptObj.CreateShortcut($ShortcutPath2)
$shortcut3 = $WscriptObj.CreateShortcut($ShortcutPath3)
$shortcut4 = $WscriptObj.CreateShortcut($ShortcutPath4)
$shortcut5 = $WscriptObj.CreateShortcut($ShortcutPath5)

$shortcut1.TargetPath = $SourceFilePath1
$shortcut2.TargetPath = $SourceFilePath2
$shortcut3.TargetPath = $SourceFilePath3
$shortcut4.TargetPath = $SourceFilePath4
$shortcut5.TargetPath = $SourceFilePath5

$shortcut1.WindowStyle = 1
$shortcut2.WindowStyle = 1
$shortcut3.WindowStyle = 1
$shortcut4.WindowStyle = 1
$shortcut5.WindowStyle = 1

$shortcut1.Save()
$shortcut2.Save()
$shortcut3.Save()
$shortcut4.Save()
$shortcut5.Save()
