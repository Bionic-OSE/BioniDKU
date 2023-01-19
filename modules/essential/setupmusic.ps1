$workdir = "$PSScriptRoot\..\.."
$pwsh = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Pwsh
$hell = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").WelcomeToHell
if ($pwsh -eq 7) {
	$chichi = Get-Content -Path $workdir\utils\liyue.xml -Raw -Encoding utf8
	$qiqi = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("$chichi"))
	Copy-Item -Path $workdir\utils\statueof7.rar -Destination "$workdir\music\normal\$qiqi.mp3" -Force
}

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Add-Type -AssemblyName presentationCore
Install-Module MusicPlayer -scope CurrentUser -Verbose -Repository 'PSGallery'
Install-Package MusicPlayer # In case if the above commands fail, this one worked flawlessly
Import-Module MusicPlayer -Verbose

if ($hell -eq 1) {
	Music $workdir\music\redstone2 -Shuffle -Loop
} else {
	Music $workdir\music\normal -Shuffle -Loop
}
Read-Host