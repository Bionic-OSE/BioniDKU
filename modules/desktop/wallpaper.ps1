Write-Host "Setting Wallpaper" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
Write-Host "Wallpaper source: https://www.reddit.com/r/Genshin_Impact/comments/sk74fe/chinju_forest_inazuma_viewpoint_art/"
Set-WallPaper -Image $workdir\utils\background.png
Start-Sleep -Seconds 2