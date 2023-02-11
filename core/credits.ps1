Show-Branding clear
function Write-Hhhh($name,$link) {
	Write-Host $name -ForegroundColor White -n; Write-Host $link
}

Write-Host "BioniDKU is made possible by the original AutoIDKU project and the following free software/solutions:" -ForegroundColor Black -BackgroundColor Cyan
Write-Host " "

Write-Host "########### SECTION 1: BioniDKU Core ############" -ForegroundColor Cyan
Write-Host " "
Write-Hhhh " - Microsoft PowerShell platform" ": https://learn.microsoft.com/en-us/powershell"
Write-Host " - AutoIDKU" -ForegroundColor Green -n; Write-Host ": https://github.com/sunryze-git/AutoIDKU/tree/8f12315"
Write-Hhhh " - 7-Zip CLI standalone" " (7za.exe & 7zxa.dll): https://www.7-zip.org/a/7z2201-extra.7z"
Write-Host " "
Write-Host "###### SECTION 2: BioniDKU User experience ######" -ForegroundColor Cyan
Write-Host " "
Write-Host " Programs included in the Utilities package:" -ForegroundColor Blue
Write-Hhhh " - AutoHotKey" " (AddressBarRemover2, BioniDKU Quick Menu tray app): https://www.autohotkey.com"
Write-Hhhh " - AdvancedRun" " (Hikaru-chan): https://www.nirsoft.net/utils/advanced_run.html"
Write-Hhhh " - PE Network Manager" ": https://www.penetworkmanager.de"
Write-Hhhh " - Paint.NET" ": https://www.getpaint.net"
Write-Hhhh " - Classic Task manager & System Configuration" ": https://win7games.com/#taskmgr7"
Write-Hhhh " - WinXShell" " (Windows Update mode shell): https://theoven.org/viewtopic.php?t=89"
Write-Hhhh " - Wu10Man" ": https://github.com/WereDev/Wu10Man"
Write-Host " Programs installed during script execution:" -ForegroundColor Blue
Write-Hhhh " - Winaero Tweaker" ": https://winaerotweaker.com"
Write-Hhhh " - Open-Shell" ": https://github.com/Open-Shell/Open-Shell-Menu"
Write-Hhhh " - T-Clock" ": https://github.com/White-Tiger/T-Clock"
Write-Hhhh " - Mozilla Firefox ESR" ": https://www.mozilla.org/en-US/firefox/enterprise"
Write-Hhhh " - ShareX" ": https://getsharex.com"
Write-Hhhh " - Notepad++" ": https://notepad-plus-plus.org"
Write-Host " Cosmetic elements:" -ForegroundColor Blue
Write-Hhhh " - Desktop background" " (Normal mode): 
   https://www.reddit.com/r/Genshin_Impact/comments/sk74fe/chinju_forest_inazuma_viewpoint_art"
Write-Hhhh " - Desktop background" " (Windows Update mode):
   https://msdesign.blob.core.windows.net/wallpapers/microsoft_brand_heritage_04.jpg"
Write-Hhhh " - Ambient sound package" " (Script sound effects and Hikaru startup sounds): 
   Extracted from Genshin Impact in-game sounds effects. (c) COGNOSPHERE PTE. LTD."
Write-Host " "
Write-Host "####### SECTION 3: BioniDKU Contributors ########" -ForegroundColor Cyan
Write-Host " "
Write-Host " I would also like to thank the following people for making this script possible:" -ForegroundColor Blue
Write-Host " (All usernames listed below are Discord usernames)"
Write-Host " - AutoIDKU author" -ForegroundColor Green -n; Write-Host ": @sunryze#5817"
Write-Hhhh " - Volunteered testers" ": @Julia#6033, @Zippykool#3826"
Write-Host " "
Write-Host " "
Write-Host "Press Enter to return to the selection screen." -ForegroundColor Yellow
Read-Host
