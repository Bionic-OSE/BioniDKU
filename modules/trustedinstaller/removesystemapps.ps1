Write-Host "Disabling some System Apps" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)

function Rename-AppsFolder($ogn,$nwn) {
	Rename-Item -Path $ogn -NewName $nwn -Force
}

# Microsoft Edge Chromium
$edghouse = "$env:SYSTEMDRIVE\Program Files (x86)\Microsoft"
$edgoogle = Test-Path "$edghouse\Edge"
$edgecore = Test-Path "$edghouse\EdgeCore"
$edgeview = Test-Path "$edghouse\EdgeWebView"
$edgupdte = Test-Path "$edghouse\EdgeUpdate"
taskkill /f /im msedge.exe
taskkill /f /im msedgewebview.exe
taskkill /f /im MicrosoftEdgeUpdate.exe
switch ($true) {
	$edgoogle {
		Rename-AppsFolder "$edghouse\Edge" "EEEE"
	}
	$edgecore {
		Rename-AppsFolder "$edghouse\EdgeCore" "EEEECCCC"
	}
	$edgeview {
		Rename-AppsFolder "$edghouse\EdgeWebView" "EEEEWWWVVVV"
	}
	$edgupdte {
		Rename-AppsFolder "$edghouse\EdgeUpdate" "EEEEUUUUUU"
	}
}

# Microsoft Edge Legacy and other system UWPs
$sappfldr = "$env:SYSTEMDRIVE\Windows\SystemApps"
$edgexaml = Test-Path "$sappfldr\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
$lockxaml = Test-Path "$sappfldr\Microsoft.LockApp_cw5n1h2txyewy"
taskkill /f /im ApplicationFrameHost.exe
switch ($true) {
	$edgexaml {
		Rename-AppsFolder "$sappfldr\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" "Microsoft.MicrosoftEdge_8wekyb3d8bbwe.DISABLED"
	}
	$lockxaml {
		Rename-AppsFolder "$sappfldr\Microsoft.LockApp_cw5n1h2txyewy" "Microsoft.LockApp_cw5n1h2txyewy.DISABLED"
	}
}

Write-Host -ForegroundColor Green -BackgroundColor DarkGray "The Apps should be disabled now" -n; Write-Host ([char]0xA0)
Start-Sleep -Seconds 5