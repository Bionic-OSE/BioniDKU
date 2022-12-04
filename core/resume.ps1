$manmode = Test-Path Test-Path -Path "$PSScriptRoot\launcherman.bat" -PathType Leaf
if ($manmode -eq $true) {
	"@echo off & start C:\Windows\System32\cmd.exe /c $PSScriptRoot\launcherman.bat" | Out-File -FilePath "C:\Windows\resume.bat" -Encoding ascii
}
else {
	"@echo off & start $PSScriptRoot\launcher.exe" | Out-File -FilePath "C:\Windows\resume.bat" -Encoding ascii
}
Copy-Item "$PSScriptRoot\resume.lnk" -Destination "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"