$chonked = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").cWUfirm
switch ($true) {
	{$edition -like "EnterpriseS*" -and $build -in 10240, 14393} {exit}
	{$chonked -eq 0 -or $build -ge 17134} {exit}
}

Write-Host -ForegroundColor Cyan "For versions 1507 to 1709, the cummulative update to the latest UBR comes in a HUGE corresponding update file (>1GB). In order to reduce the hassle for PSWindowsUpdate, the script will now download the update and have you install it. After the installation, you can continue updating by interrupting Windows Update mode on startup. "; Write-Host -ForegroundColor Yellow "Does that sound good?"
Write-Host "YES to proceed, anything else to skip and have PSWindowsUpdate do the job like usual." -ForegroundColor White
Write-Host " "
Write-Host "> " -n ; $confules = Read-Host
switch ($true) {
	{$confules -like "yes"} {
		Write-Host -ForegroundColor Green "Got it, starting to download the update"
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "cWUfirm" -Value 1 -Type DWord -Force
	}
	default {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "cWUfirm" -Value 0 -Type DWord -Force
	}
}
$chonkfirm = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").cWUfirm; if ($chonkfirm -eq 0) {
	Write-Host " "
	Write-Host -ForegroundColor Cyan "Alright, we will let PSWindowsUpdate handle the task."
	Write-Host -ForegroundColor White 'If you did this by accident, open Registry Editor, navigate to "HKCU\SOFTWARE\AutoIDKU", set "cWUfirm" to 1, then sign out and sign back in.'
	Start-Sleep -Seconds 5
	Write-Host " "
	exit
}

switch ($build) {
	10240 {$stackdate = $null}
	10586 {$stackdate = "http://download.windowsupdate.com/d/msdownload/update/software/crup/2017/08/windows10.0-kb4035632-x64_ea26f11d518e5e363fe9681b290a56a6afe15a81.msu"}
	14393 {
		$stackdate = "https://catalog.s.download.windowsupdate.com/d/msdownload/update/software/secu/2019/02/windows10.0-kb4485447-x64_e9334a6f18fa0b63c95cd62930a058a51bba9a14.msu"
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "WelcomeToHell" -Value 1 -Type DWord -Force
	}
	15063 {$stackdate = "https://catalog.s.download.windowsupdate.com/d/msdownload/update/software/secu/2019/09/windows10.0-kb4521859-x64_4b0272df95f1a1167da05fe7640e1620b66ad470.msu"}
	16299 {$stackdate = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/secu/2020/07/windows10.0-kb4565553-x64_37666386a4858aed971874a72cb8c07155c26a87.msu"}
}

$chonkfirm2 = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").cWUfirm; if ($chonkfirm2 -ne 2) {
	Write-Host -ForegroundColor Cyan "Updating your Servicing Stack first..."
	Import-Module BitsTransfer
	$stacktries = 1
	while ($stacktries -le 5) {
		Start-BitsTransfer -DisplayName "Downloading Servicing Stack update" -Description "For OS build $build" -Source $stackdate -Destination "$datadir\dls\SSU.msu" -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		if (Test-Path -Path "$datadir\dls\SSU.msu" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor Black -BackgroundColor Red "Ehhhhhhh"
			Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
			$stacktries++
		}
	}
	if ($stacktries -le 5) {
		Start-Process wusa.exe -Wait -ArgumentList "/quiet /norestart SSU.msu"
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "cWUfirm" -Value 2 -Type DWord -Force
	} else {Write-Host -ForegroundColor Black -BackgroundColor Red "Failed to download the servicing stack update." -n; Write-Host -ForegroundColor White " Proceeding to download the cummulative update anyways. Sign out and back in if you want to retry downloading."; Start-Sleep -Seconds 5}
}

switch ($edition) {
	default {
		switch ($build) {
			10240 {$chonkdate = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2017/06/windows10.0-kb4032695-x64_ce02f93e314452c2dabd74bfbe536db170560ce6.msu"}
			10586 {$chonkdate = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2017/11/windows10.0-kb4052232-x64_342abf55b673bd4d9ad963b9c4127b93d54bfee8.msu"}
			14393 {$chonkdate = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/updt/2018/04/windows10.0-kb4093120-x64_72c7d6ce20eb42c0df760cd13a917bbc1e57c0b7.msu"}
			15063 {$chonkdate = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/updt/2018/10/windows10.0-kb4462939-x64_68fa7ea1928f909b1497d61c0819aebaf7c37fa8.msu"}
			16299 {$chonkdate = "http://download.windowsupdate.com/c/msdownload/update/software/secu/2019/04/windows10.0-kb4493441-x64_2553aab51f8d8c5e8382750c094c9fe54b2156c1.msu"}
		}
	}
	{$_ -match "Enterprise" -or $_ -like "Education"} {
		switch ($build) {
			10240 {$chonkdate = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2017/06/windows10.0-kb4032695-x64_ce02f93e314452c2dabd74bfbe536db170560ce6.msu"}
			10586 {$chonkdate = "http://download.windowsupdate.com/d/msdownload/update/software/secu/2018/03/windows10.0-kb4093109-x64_23878b35ac2f25483092cd28fb75b5c75b5d4ae1.msu"}
			14393 {$chonkdate = "https://catalog.s.download.windowsupdate.com/d/msdownload/update/software/secu/2019/04/windows10.0-kb4493470-x64_2d9533301a1e6b5fb0c1c200df8a060bcc97b7d3.msu"}
			15063 {$chonkdate = "https://download.windowsupdate.com/c/msdownload/update/software/secu/2019/10/windows10.0-kb4520010-x64_7b8a25ba95388462293292f791314f01e5ad0acd.msu"}
			16299 {$chonkdate = "http://download.windowsupdate.com/d/msdownload/update/software/secu/2020/10/windows10.0-kb4580328-x64_b0565c3b26e77c3ce230a19121e30dccfb756235.msu"}
		}
	}
}

$cwuf = (Get-ChildItem -Path $datadir\dls -Filter windows*.msu)
$chonkexists = Test-Path -Path "$datadir\dls\$cwuf" -PathType Leaf
Start-Process powershell -ArgumentList "-Command $workdir\modules\removal\wukiller.ps1"
if ($chonkexists -eq $false) {
	Write-Host -ForegroundColor Cyan "Now downloading the CHUNGUS update..."
	while ($true) {
		Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "--tries 7 --show-progress -c $chonkdate" -WorkingDirectory $datadir\dls
		$cwuf = (Get-ChildItem -Path $datadir\dls -Filter windows*.msu)
		if (Test-Path -Path "$datadir\dls\$cwuf" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor Black -BackgroundColor Red "Ehhhhhhh"
			Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
		}
	}
	Show-WindowTitle
	Write-Host -ForegroundColor Cyan "Download complete. Opening the MSU in wusa.exe so you can install it..."
} else {
	Write-Host -ForegroundColor Cyan "It looks like the update file has downloaded before. Moving on to handle the task using wusa.exe..."
}
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "WuKillerStop" -Value 1 -Type DWord -Force

Start-Sleep -Seconds 5
Start-Service -Name wuauserv
Start-Process wusa.exe -NoNewWindow -ArgumentList "$datadir\dls\$cwuf"
Write-Host " "; Write-Host -ForegroundColor Yellow "Wait for a while, then when it prompts you to install, click Yes and let it install the update. When it's done, you can restart using the button on the prompt, or by coming back here and pressing Enter TWICE."
Write-Host "If wusa.exe fails to open, you can manually open the update at $datadir\dls\$cwuf"
Write-Host "Good luck updating!" -ForegroundColor White

& $workdir\modules\essential\cWUngun.ps1
Read-Host; Read-Host
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Looks like you're done. Restarting..."
Start-Sleep -Seconds 5
shutdown -r -t 0
Start-Sleep -Seconds 30
