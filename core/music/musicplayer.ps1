# BioniDKU music player - Powered by FFPlay - (c) Bionic Butter

Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMusicStop" -Value 0 -Type DWord -Force
function Show-NotifyBalloon($title,$message1,$message2) {
	[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
	$Global:Balloon = New-Object System.Windows.Forms.NotifyIcon
	$Balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$PSScriptRoot\musicplayer.ico")
	$Balloon.BalloonTipText = @"
$message1
$message2
"@
	$Balloon.BalloonTipTitle = $title
	$Balloon.Visible = $true
	$Balloon.ShowBalloonTip(1000)
}
function Show-Branding {
	[console]::CursorVisible = $false
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Music player module" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}
function Start-Shuffling {
	Show-Branding
	Write-Host "Shuffling..." -ForegroundColor White
	$listraw = @(Get-ChildItem "$datadir\music" -Recurse -Include *.mp3 | %{$_.fullname})
	$list = $listraw | Sort-Object {Get-Random}
	$list | Out-File -Append $datadir\values\playlist.txt
}
$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Music player module"
$global:workdir = Split-Path(Split-Path "$PSScriptRoot")
$global:datadir = "$workdir\data"

while ($true) {
	try {
		[string[]]$playlist = Get-Content -Path $datadir\values\playlist.txt -ErrorAction SilentlyContinue
		[int32]$playposit = Get-Content -Path $datadir\values\playpos.txt -ErrorAction SilentlyContinue
		if ($playposit -gt $playlist.Length -or $playlist -eq $null) {throw}
	} catch {
		Start-Shuffling
		[string[]]$playlist = Get-Content -Path $datadir\values\playlist.txt
		[int32]$playposit = 0
	}

	for ($playposit; $playposit -le $playlist.Length; $playposit++) {
		Show-Branding
		[int32]$playposit + 1 | Out-File -FilePath $datadir\values\playpos.txt
		$song = $playlist[$playposit]
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
		$Balloon.Visible = $false
		$playstop = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusicStop
		if ($playstop -eq 1) {exit}
	}
}
