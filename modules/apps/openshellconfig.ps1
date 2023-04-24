if ($essentialapps -ne $true) {exit}
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing Open-Shell and importing its configuration" -n; Write-Host ([char]0xA0)
Start-Process $workdir\dls\openshellinstaller.exe -Wait -NoNewWindow -ArgumentList "/qn ADDLOCAL=StartMenu"
Expand-Archive -Path $workdir\utils\Fluent.zip -DestinationPath "$env:PROGRAMFILES\Open-Shell\Skins"
Start-Process "$env:PROGRAMFILES\Open-Shell\StartMenu.exe" -NoNewWindow -ArgumentList "-xml $workdir\utils\menu.xml"
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling App Dark Mode, forcing Dark Taskbar" -n; Write-Host ([char]0xA0)
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Value 0 -Type DWord -Force
