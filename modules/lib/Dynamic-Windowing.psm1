# BioniDKU Dynamic Window handles

function Show-WindowTitle($s1,$s2,$s3) {
	<#
	Variables explaination
	- $s1: Phase number. Phase 0 turns the whole phase text ($ph) to "Main menu"
	- $s2: Before phase 3, this is for the mode name. During phase 3, this will be the progress percentage
	- $s3: No close flag
	#>

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
function Set-WindowState {
	<#
	From https://gist.github.com/prasannavl/effd901e2460a651ad2c
	
	.SYNOPSIS
		Set a given window state using WinAPI.
	.DESCRIPTION
		Use the ShowWindowAsync function to set the Window state for 
		any given window handle or the current powershell process.
	.EXAMPLE
		Set-WindowState -State "MINIMIZE"
		Minimizes the window where the command is executed.
	.EXAMPLE
		Set-WindowState -State "MINIMIZE" -MainWindowHandle (ps chrome | select -First 1).Handle
		Minimizes the window of the given handle.
	#>

	param(
	[Parameter()]
	[ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE',
	'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED',
	'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
	$State = 'SHOW',
	[Parameter()]
	$MainWindowHandle = (Get-Process -id $pid).MainWindowHandle
	)

	$WindowStates = @{
		'FORCEMINIMIZE' = 11
		'HIDE' = 0
		'MAXIMIZE' = 3
		'MINIMIZE' = 6
		'RESTORE' = 9
		'SHOW' = 5
		'SHOWDEFAULT' = 10
		'SHOWMAXIMIZED' = 3
		'SHOWMINIMIZED' = 2
		'SHOWMINNOACTIVE' = 7
		'SHOWNA' = 8
		'SHOWNOACTIVATE' = 4
		'SHOWNORMAL' = 1
	}

	$Win32ShowWindowAsync = Add-Type -name "Win32ShowWindowAsync" -namespace Win32Functions -passThru -memberDefinition '
	[DllImport("user32.dll")]
	public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
	'

	$Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[($State)]) | Out-Null
}
