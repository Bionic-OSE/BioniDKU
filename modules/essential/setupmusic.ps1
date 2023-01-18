$workdir = "$PSScriptRoot\..\.."
$pwsh = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Pwsh
if ($pwsh -eq 7) {
	$chichi = Get-Content -Path $workdir\utils\liyue.xml -Raw -Encoding utf8
	$qiqi = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("$chichi"))
	Copy-Item -Path $workdir\utils\statueof7.rar -Destination "$workdir\music\normal\$qiqi" -Force
}

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Add-Type -AssemblyName presentationCore
Install-Module MusicPlayer -scope CurrentUser -Verbose -Repository 'PSGallery'
Install-Package MusicPlayer # In case if the above commands fail, this one worked flawlessly
Import-Module MusicPlayer -Verbose

Music $workdir\music\normal -Shuffle -Loop -Verbose
Read-Host