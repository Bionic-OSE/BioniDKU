# BioniDKU Dynamic Titlebar

## Variables explaination
# $s1: Phase number. Phase 0 turns the whole phase text ($ph) to "Main menu"
# $s2: Before phase 3, this is for the mode name. During phase 3, this will be the progress percentage
# $s3: No close flag

function Show-WindowTitle($s1,$s2,$s3) {
	switch ($s1) {
		default {$pg = " - ${s2}"; $nd = " OR DISCONNECT INTERNET"}
		{$_ -eq 0 -or $_ -eq 4} {$pg, $nd = $null}
		3 {$pg = " (Progress: ${s2}%)"; $nd = $null}
	}
	if ($s3 -like "noclose") {$nc = " | DO NOT CLOSE THIS WINDOW${nd}"} else {$nc = $null}
	if ($s1 -eq 0) {$ph = "Main menu"} elseif ($s1 -eq 4) {$ph = "Operation completed"} else {$ph = "Phase ${s1}/3"}
	$rid = (Get-ItemProperty -Path "HKCU:\Software\BioniDKU").ReleaseID; $vid = $rid.Substring(6)
	$host.UI.RawUI.WindowTitle = "Project BioniDKU (Version ${vid}) - (c) Bionic Butter | ${ph}${pg}${nc}"
}
