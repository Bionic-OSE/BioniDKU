$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter and Sunryze | UWP apps removal module"
function Show-Branding { # Has to declare it here again because of a different PowerShell process
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Magenta -n; Write-Host ([char]0xA0)
	Write-Host "UWP apps removal module" -ForegroundColor Cyan -BackgroundColor Gray -n; Write-Host ([char]0xA0)
	Write-Host " "
}
Show-Branding
Write-Host -ForegroundColor Black -BackgroundColor Yellow "DO NOT CLOSE THIS WINDOW!" -n; Write-Host ([char]0xA0)
Write-Host " " 
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "This process will spit out A LOT of errors, and that is normal. It will start in 5 seconds." -n; Write-Host ([char]0xA0)
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "In addition, if you are sensitive to flashes, please minimize or do not look at this window." -n; Write-Host ([char]0xA0)
Write-Host " " 

Start-Sleep -Seconds 5
$pwsh = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Pwsh
if ($pwsh -eq 7) {Import-Module -Name Appx -UseWindowsPowerShell}
Get-AppxPackage | Remove-AppxPackage
Get-AppxPackage -AllUsers | Remove-AppxPackage
Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
Start-Sleep -Seconds 10