$edgexists = Test-Path "$env:USERPROFILE\Desktop\Microsoft Edge.lnk" -PathType Leaf
$edgexistance = Test-Path "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" -PathType Leaf
$edgooglexists = Test-Path "$env:SYSTEMDRIVE\Users\Public\Desktop\Microsoft Edge.lnk" -PathType Leaf
$kbscam = Test-Path "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\PC Health Check.lnk" -PathType Leaf
switch ($true) {
    $edgexists {
        Write-Host "Removing Microsoft Edge shortcut from the Desktop and Start Menu" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
        Remove-Item -Path "$env:USERPROFILE\Desktop\Microsoft Edge.lnk" -Force
    }
	$edgooglexists {
        Write-Host "Removing Microsoft Edge shortcut from the Desktop and Start Menu" -ForegroundColor Cyan -BackgroundColor DarkGray -n; Write-Host ([char]0xA0)
        Remove-Item -Path "$env:SYSTEMDRIVE\Users\Public\Desktop\Microsoft Edge.lnk" -Force
    }
	$edgexistance {
		Remove-Item -Path "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" -Force
	}
	$kbscam {
		Write-Host 'Also removing the PC Health Check shortcut that was installed via an "update". More information about this: https://youtu.be/_D3YSOsed9E'
		Start-Sleep -Seconds 2
		Remove-Item -Path "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\PC Health Check.lnk"
	}
}
