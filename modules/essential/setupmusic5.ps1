$workdir = "$PSScriptRoot\..\.."

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Add-Type -AssemblyName presentationCore
Install-Module MusicPlayer -scope CurrentUser -Verbose -Repository 'PSGallery'
Import-Module MusicPlayer -Verbose

Music $workdir\music\normal -Shuffle -Loop -Verbose
Read-Host