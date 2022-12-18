$chichi = Get-Content -Path $workdir\music\liyue.xml -Raw -Encoding utf8
$qiqi = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("$chichi"))
Copy-Item -Path $workdir\utils\statueof7.rar -Destination "$workdir\music\normal\$qiqi" -Force

Music $workdir\music\normal -Shuffle -Loop -Verbose
