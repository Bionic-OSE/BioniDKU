# This module removes the regular Downloads folder, creates a replacement one (named DL), and pins it to This PC based on the method Winaero Tweaker uses

# Remove the folder (this will also unpin Downloads from all users)
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing Downloads folder"
$dlhasfiles = Test-Path -Path "$env:USERPROFILE\Downloads\*"
if ($dlhasfiles -eq $true) {
	Write-Host "DELETING YOUR DOWNLOADS FOLDER as you specified." -ForegroundColor Red -BackgroundColor DarkGray
	Import-Module -Name $workdir\modules\lib\Remove-ItemWithProgress.psm1
	Remove-ItemWithProgress -Path "$env:USERPROFILE\Downloads"
} else {
	Remove-Item -Path "$env:USERPROFILE\Downloads" -Force -Recurse
}
Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}' -Force 
Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}' -Force

# Create the replacement folder
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Creating replacement Downloads (DL) folder"
New-Item -Path $env:USERPROFILE -Name DL -itemType Directory
@"
[.ShellClassInfo]
IconResource=$env:SYSTEMDRIVE\WINDOWS\System32\SHELL32.dll,122
"@ | Out-File $env:USERPROFILE\DL\desktop.ini -Encoding "ASCII"
Start-Process attrib -ArgumentList "$env:USERPROFILE\DL\desktop.ini +S +H"
Start-Process attrib -ArgumentList "$env:USERPROFILE\DL +R"
if ($desktopshortcuts) {Expand-Archive -Path $datadir\utils\dl.zip -DestinationPath $env:USERPROFILE\Desktop}

# Finally, pin it to This PC
if (-not (Test-Path $datadir\utils\DL.reg)) {
	$duid = (New-GUID).GUID
	$upth = $env:USERPROFILE.replace('\','\\')
	
	$dreg = @"
Windows Registry Editor Version 5.00 - BioniDKU Downloads (DL) folder on This PC view

[HKEY_CURRENT_USER\Software\Classes\CLSID\#${duid}&]
@="Downloads"
"InfoTip"="The BioniDKU Downloads folder"
"{305ca226-d286-468e-b848-2b2e8e697b74} 2"=dword:ffffffff
"DescriptionID"=dword:00000003
"System.IsPinnedtoNameSpaceTree"=dword:00000001

[HKEY_CURRENT_USER\Software\Classes\CLSID\#${duid}&\DefaultIcon]
@="$env:SYSTEMDRIVE\\WINDOWS\\system32\\shell32.dll,122"

[HKEY_CURRENT_USER\Software\Classes\CLSID\#${duid}&\InProcServer32]
@="shdocvw.dll"
"ThreadingModel"="Both"

[HKEY_CURRENT_USER\Software\Classes\CLSID\#${duid}&\Instance]
"CLSID"="{0afaced1-e828-11d1-9187-b532f1e9575d}"

[HKEY_CURRENT_USER\Software\Classes\CLSID\#${duid}&\Instance\InitPropertyBag]
"Attributes"=dword:00000015
"Target"="${upth}\\DL"

[HKEY_CURRENT_USER\Software\Classes\CLSID\#${duid}&\ShellEx]

[HKEY_CURRENT_USER\Software\Classes\CLSID\#${duid}&\ShellEx\PropertySheetHandlers]

[HKEY_CURRENT_USER\Software\Classes\CLSID\#${duid}&\ShellEx\PropertySheetHandlers\tab 1 general]
@="{21b22460-3aea-1069-a2dc-08002b30309d}"

[HKEY_CURRENT_USER\Software\Classes\CLSID\#${duid}&\ShellEx\PropertySheetHandlers\tab 2 customize]
@="{ef43ecfe-2ab9-4632-bf21-58909dd177f0}"

[HKEY_CURRENT_USER\Software\Classes\CLSID\#${duid}&\ShellEx\PropertySheetHandlers\tab 3 sharing]
@="{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"

[HKEY_CURRENT_USER\Software\Classes\CLSID\#${duid}&\ShellEx\PropertySheetHandlers\tab 4 security]
@="{1f2e5c40-9550-11ce-99d2-00aa006e086c}"

[HKEY_CURRENT_USER\Software\Classes\CLSID\#${duid}&\ShellFolder]
"Attributes"=dword:f080004d
"WantsFORPARSING"=""
"HideAsDeletePerUser"=""

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\#${duid}&]
"@
	$dreg.replace('#','{').replace('&','}') | Out-File $datadir\utils\DL.reg -Encoding "ASCII"
}
reg import $datadir\utils\DL.reg
