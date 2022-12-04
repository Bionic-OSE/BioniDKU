$qiqi = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('UGjhuqFtIFF14buzbmggQW5oIC0gSGVsbG8gVmlldG5hbS5tcDM='))
Copy-Item -Path $workdir\utils\statueof7.zip -Destination "$workdir\music\normal\$qiqi" -Force

Music $workdir\music\normal -Shuffle -Loop -Verbose
