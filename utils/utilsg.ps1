$host.UI.RawUI.WindowTitle = "Project BioniDKU - (c) Bionic Butter | Utilites fetcher module - DO NOT CLOSE THIS WINDOW"
$uexists = Test-Path -Path "$PSScriptRoot\WinXShell.zip" -PathType Leaf
if ($uexists) {exit}
function Show-Branding {
	Clear-Host
	Write-Host 'Project BioniDKU - Next Generation AutoIDKU' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Utilites fetcher module" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}
Show-Branding
Import-Module BitsTransfer

# IMPORTANT SECTION
$utag = "300_u1"
$unum = 2

for ($u = 1; $u -le $unum; $u++) {
	while ($true) {
		Start-BitsTransfer -Source "https://github.com/Bionic-OSE/BioniDKU-utils/releases/download/$utag/utils.7z.00$u" -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		if (Test-Path -Path "$PSScriptRoot\utils.7z.00$u" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor Black -BackgroundColor Red "Uhhhhhhh"
			Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
		}
	}
}
Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "e $PSScriptRoot\utils.7z.001 -o$PSScriptRoot -y"
