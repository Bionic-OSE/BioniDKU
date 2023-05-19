# BioniDKU Windows Update mode - Update Build Revision numbers

# The purpose of this file is so I can update the UBRs every month without having to update the whole script package. This change takes effect starting with version 300_update1
# Windows Update mode supports Windows 10, version 1607 and later, which includes PowerShell 5.1. Version 1507 and 1511 are not supported due to 5.0 not having required functions for PSWindowsUpdate to work.

. $workdir\modules\lib\GetEdition.ps1
switch ($edition) {
	
	# Consumer and any other editions
	{$_ -notlike "Enterprise" -or $_ -notlike "Education"} {$latest = @(
		<# ======= EOL builds ======= #>
		<# 1607 #>          "14393.2214"
		<# 1703 #>          "15063.1418"
		<# 1709 #>          "16299.1087"
		<# 1803 #>          "17134.1304"
		<# 1809 #>          "17763.1577"
		<# 1903 #>          "18362.1256"
		<# 1909 #>          "18363.1556"
		<# 2004 #>          "19041.1415"
		<# 20H2 #>          "19042.1706"
		<# 21H1 #>          "19043.2364"
		<# ====== Alive builds ====== #>
		<# 21H2 #>          "14044.2965"
		<# 22H2 #>          "14045.2965"
	)}
	
	# Commerical editions
	{$_ -like "Enterprise" -or $_ -like "Education"} {$latest = @(
		<# ======= EOL builds ======= #>
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
		<# 21H2 #>          "14044.2965"
		<# 22H2 #>          "14045.2965"
	)}
	
	# Long-term servicing editions
	{$_ -like "EnterpriseS"} {$latest = @(
		<# ====== Alive builds ====== #>
		<# LTSB 2016 #>     "14393.5921"
		<# LTSC 2019 #>     "14393.4377"
		<# LTSC 2021 #>     "14044.2965"
	)}
	
	# Server editions (Why? Perhaps Nana can answer that question...)
	{$_ -like "ServerStandard" -or $_ -like "ServerDatacenter" -or $_ -like "ServerStandardEval" -or $_ -like "ServerDatacenterEval"} {$latest = @(
		<# ====== Alive builds ====== #>
		<# Server 2016 #>   "14393.5921"
		<# Server 2019 #>   "14393.4377"
		<# Server 2022 #>   "20348.1726"
	)}
	
}