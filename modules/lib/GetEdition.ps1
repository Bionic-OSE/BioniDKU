# BioniDKU Windows Edition grabber
# This is for the script to print out the exact name of the various Windows 10 editions it covers.

$edition = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").EditionID
switch ($edition) {
	default {$editiontype = "10"}
	{$_ -like "ServerStandard" -or $_ -like "ServerDatacenter" -or $_ -like "ServerStandardEval" -or $_ -like "ServerDatacenterEval"} {$editiontype = "Server"}
}
switch ($edition) {
	default {$editiond = "$edition"}
	{$_ -like "Core"} {$editiond = "Home"}
	{$_ -like "Professional"} {$editiond = "Pro"}
	{$_ -like "ProfessionalWorkstation"} {$editiond = "Pro for Workstations"}
	{$_ -like "EnterpriseS"} {
		if ($build -eq 14393) {$editiond = "LTSB 2016"}
		elseif ($build -eq 17763) {$editiond = "LTSC 2019"}
		elseif ($build -eq 19044) {$editiond = "LTSC 2021"}
		else {$editiond = "LTSB/LTSC"}
	}
	{$_ -like "EnterpriseG"} {
		if ($build -eq 17134) {$editiond = "Enterprise for China Goverment (CMGE V0)"}
		elseif ($build -eq 17763) {$editiond = "Enterprise for China Goverment (CMGE V2020)"}
		elseif ($build -eq 19044) {$editiond = "Enterprise for China Goverment (CMGE V2022)"}
		else {$editiond = "Enterprise for China Goverment"}
	}
	{$_ -like "ServerStandard" -or $_ -like "ServerDatacenter"} {
		# As a matter of fact, Server is technially regular Windows but with Server stuffs bundled.
		if ($build -eq 14393) {$editiond = "2016"}
		elseif ($build -eq 17763) {$editiond = "2019"}
		elseif ($build -eq 20348) {$editiond = "2022"}
		else {$editiond = "operating system"}
	}
	{$_ -like "ServerStandardEval" -or $_ -like "ServerDatacenterEval"} {
		if ($build -eq 14393) {$editiond = "2016 Evaluation"}
		elseif ($build -eq 17763) {$editiond = "2019 Evaluation"}
		elseif ($build -eq 20348) {$editiond = "2022 Evaluation"}
		else {$editiond = "Evaluation"}
	}
}
