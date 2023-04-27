Remove-ItemProperty -Path "HCKU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies" -Name "Wallpaper" -ErrorAction SilentlyContinue

function Set-WallPaper($Image) {
Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}

Write-Host "Setting Wallpaper" -ForegroundColor Cyan -BackgroundColor DarkGray
Write-Host "Wallpaper source: " -ForegroundColor Cyan -n; Write-Host "https://www.reddit.com/r/Genshin_Impact/comments/sk74fe/chinju_forest_inazuma_viewpoint_art/"
Set-WallPaper -Image "$env:SYSTEMDRIVE\Bionic\BioniDKU.png"
Start-Sleep -Seconds 2
