# BioniDKU Windows Edition grabber
# This is for the script to print out the exact name of the various Windows 10 editions it covers.

## Variables explaination
# $edition: The raw edition value straight from the registry
# $editionn: In case if the edition is a N, this will be $edition but with the 'N' trimmed off for the detection system below
# $editionf: F for "Fancy". This is the full name of the edition
# $editione: Just for the "N" at the end
# $editiond = $editionf + $editione. This is the final edition display string the script will give

$edition = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").EditionID

# OS type detection
switch ($edition) {
	default {$editiontype = "10"}
	{$_ -like "Server*"} {$editiontype = "Server"}
}

# N edition detection
if ($edition -match ".*N$") {$editionn = "$($edition.TrimEnd('N'))"; $editione = " N"} else {$editionn = $edition; $editione = $null}

# Full name query
switch ($editionn) {
	default {$editionf = "$edition"}
	"Core" {$editionf = "Home"}
	"CoreSingleLanguage" {$editionf = "Home Single Language"}
	"CoreCountrySpecific" {$editionf = "Home Country Specific"}
	"Professional" {$editionf = "Pro"}
	"ProfessionalSingleLanguage" {$editionf = "Pro Single Language"}
	"ProfessionalCountrySpecific" {$editionf = "Pro Country Specific"}
	"ProfessionalEducation" {$editionf = "Pro Education"}
	"ProfessionalWorkstation" {$editionf = "Pro for Workstations"}
	"IoTEnterprise" {$editionf = "IoT Enterprise"}
	"EnterpriseEval" {$editionf = "Enterprise Evaluation"}
	"*EnterpriseS*" {
		switch ([int32]$build) {
			14393 {$ltsrel = "B 2016"}
			17763 {$ltsrel = "C 2019"}
			19044 {$ltsrel = "C 2021"}
			default {$rel = "B/LTSC"}
		}
		if ($edition -match "^IoT") {$ltsiot = "IoT "} else {$ltsiot = $null}
		if ($edition -match ".*Eval$") {$lteval = " Evaluation"} else {$lteval = $null}
		$editionf = "${ltsiot}Enterprise LTS${ltsrel}${lteval}"
	}
	"EnterpriseG" {
		switch ([int32]$build) {
			17134 {$editionf = "Enterprise for China Goverment (CMGE V0)"}
			17763 {$editionf = "Enterprise for China Goverment (CMGE V2020)"}
			{$_ -in 19044, 19045} {$editionf = "Enterprise for China Goverment (CMGE V2022)"}
			default {$editionf = "Enterprise for China Goverment"}
		}
	}
	"Server*" {
		switch ([int32]$build) {
			14393 {$srvrel = "2016"}
			17763 {$srvrel = "2019"}
			20348 {$srvrel = "2022"}
			default {$srvrel = "OS"}
		}
		if ($edition -match ".*Eval$") {$sreval = " Evaluation"} else {$sreval = $null}
		$editionf = "${ltsrel}${lteval}"
	}
}

# Assemble the final display name
$editiond = "${editionf}${editione}"
