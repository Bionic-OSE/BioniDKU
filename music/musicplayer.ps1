# BioniDKU music player - Powered by FFPlay - (c) Bionic Butter

[console]::CursorVisible = $false
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMusicStop" -Value 0 -Type DWord -Force
$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
& $PSScriptRoot\chichi.ps1
function Show-NotifyBalloon($title,$message1,$message2) {
	[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
	$Global:Balloon = New-Object System.Windows.Forms.NotifyIcon
	$Balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$PSScriptRoot\musics.ico")
	$Balloon.BalloonTipText = @"
$message1
$message2
"@
	$Balloon.BalloonTipTitle = $title
	$Balloon.Visible = $true
	$Balloon.ShowBalloonTip(1000)
}
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Music player module" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}

$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Music player module"
Show-Branding

Write-Host "Shuffling..." -ForegroundColor White

$playlist = @(Get-ChildItem "$PSScriptRoot\normal" -Recurse -Include *.mp3 | %{$_.fullname})
$playqueue = $playlist | Sort-Object {Get-Random}

foreach ($song in $playqueue) {
	Show-Branding
	$songfile = $song.Substring($song.LastIndexOf("\")+1)
	$songname = $songfile.Substring(0, $songfile.LastIndexOf("."))
	$songfpth = $song.Substring(0, $song.LastIndexOf("\"))
	$songalbp = $songfpth.Substring($songfpth.LastIndexOf("\")+1)
	$songalbm = $songalbp.Substring($songalbp.LastIndexOf(".")+2)
	Show-NotifyBalloon "Now playing" "Album: $songalbm" "Title: $songname"
	Write-Host "Now playing:" -ForegroundColor Black -BackgroundColor Cyan
	Write-Host "Album:" -ForegroundColor Cyan -n; Write-Host " $songalbm" -ForegroundColor White
	Write-Host "Title:" -ForegroundColor Cyan -n; Write-Host " $songname" -ForegroundColor White; Write-Host ' '
	Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -Wait -NoNewWindow -ArgumentList "-i `"$song`" -nodisp -loglevel quiet -stats -hide_banner -autoexit"
	#$Balloon.Dispose()
	$Balloon.Visible = $false
	$playstop = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusicStop
	if ($playstop -eq 1) {exit}
}
