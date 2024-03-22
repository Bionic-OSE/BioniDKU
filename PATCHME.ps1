# BioniDKU Download mode & Windows Update mode - Software versions information file - (c) Bionic Butter

# The purpose of this file is so I can update the version number of apps and the UBRs every month without having to update the whole script package. The UBRs section takes effect starting with version 300_update1, and the software version section starting with version 300_update5.


# SECTION 1: Software version numbers:
	<#    VLC    #> $global:VLCver = "3.0.20"
	<# OpenShell #> $global:OShellDispver = "4.4.191"; $global:OShellExecver = "4_4_191"
	<# Notepad++ #> $global:NPPver = "8.6.4"
	<#  PSCore7  #> $global:pwsh7ver = "7.4.1"

# SECTION 2: Windows Update UBRs (March 2024)
. $workdir\modules\lib\Get-Edition.ps1
switch ($edition) {
	
	# Consumer and any other editions
	default {$latest = @(
		<# ======= EOL builds ======= #>
		<# 1507 #>          "10240.17446"
		<# 1511 #>          "10586.1177"
		<# 1607 #>          "14393.2214"
		<# 1703 #>          "15063.1418"
		<# 1709 #>          "16299.1087"
		<# 1803 #>          "17134.1304" # .1130?
		<# 1809 #>          "17763.1577"
		<# 1903 #>          "18362.1256"
		<# 1909 #>          "18363.1556"
		<# 2004 #>          "19041.1415"
		<# 20H2 #>          "19042.1706"
		<# 21H1 #>          "19043.2364"
  		<# 21H2 #>          "19044.3086"
		<# ====== Alive builds ====== #>
		<# 22H2 #>          "19045.4170"
	)}
	
	# Commerical editions
	{$_ -match "Enterprise[^S]" -or $_ -like "Education" -or $_ -like "ServerRdsh"} {$latest = @(
		<# ======= EOL builds ======= #>
		<# 1511 #>          "10586.17446"
		<# 1511 #>          "10586.1540"
		<# 1607 #>          "14393.2906"
		<# 1703 #>          "15063.2108"
		<# 1709 #>          "16299.2166"
		<# 1803 #>          "17134.2208"
		<# 1809 #>          "17763.1935"
		<# 1903 #>          "18362.1256"
		<# 1909 #>          "18363.2274"
		<# 2004 #>          "19041.1415"
		<# 20H2 #>          "19042.2965"
		<# 21H1 #>          "19043.2364"
		<# ====== Alive builds ====== #>
		<# 21H2 #>          "19044.4170"
		<# 22H2 #>          "19045.4170"
	)}
	
	# Long-term servicing editions
	{$_ -match "EnterpriseS"} {$latest = @(
		<# ====== Alive builds ====== #>
		<# LTSB 2015 #>     "10240.20526"
		<# LTSB 2016 #>     "14393.6796"
		<# LTSC 2019 #>     "17763.5576"
		<# LTSC 2021 #>     "19044.4170"
	)}
	
	# Server editions
	{$_ -match "Server" -and $_ -notlike "ServerRdsh"} {$latest = @(
		<# ====== Alive builds ====== #>
		<# Server 2016 #>   "14393.6796"
		<# Server 2019 #>   "17763.5576"
		<# Server 2022 #>   "20348.2340"
	)}
	
}
