# BioniDKU Ambient sounds player module

function Play-Ambient($v) {

	switch ($v) {
		0 {Start-Process "$datadir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\SpiralAbyss.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"}

		1 {Start-Process "$datadir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainAccepted0.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"}

		2 {
			$min = 1; $max = 5
			$n = Get-Random -Minimum $min -Maximum $max
			Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\ChillWait$n.mp3 -nodisp -loglevel quiet -loop 0 -hide_banner"
		}

		3 {Start-Process "$datadir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainChallengeStart.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"}

		4 {Start-Process "$datadir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainCompleted.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"}

		5 {Start-Process "$datadir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainFailed.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"}

		6 {Start-Process "$datadir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainAmbient.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"}

		7 {Start-Process "$datadir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainBonus.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"}

		8 {Start-Process "$datadir\ambient\FFPlay.exe" -Wait -WindowStyle Hidden -ArgumentList "-i $datadir\ambient\DomainCompletedAll.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"}
	}

}
