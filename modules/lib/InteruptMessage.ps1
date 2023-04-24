function Set-BootMessage($title, $message) {
	Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'legalnoticecaption' -Value $title -Type String -Force
	Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'legalnoticetext' -Value $message -Type String -Force
}

$clsmsg = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").ClearBootMessage
if ($clsmsg -eq 1) {
	Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'legalnoticecaption' -Force -ErrorAction SilentlyContinue
	Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'legalnoticetext' -Force -ErrorAction SilentlyContinue
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "ClearBootMessage" -Value 0 -Type DWord -Force
}

$shell = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon").Shell
$manmode = Test-Path -Path "$coredir\launcherman.bat" -PathType Leaf
if ($manmode -eq $true) {
	$launcher = "$coredir\launcherman.bat"
}
else {
	$launcher = "$coredir\launcher.exe"
}
if ($shell -like "null") {
	$ttt = "Uh oh..."
	$msg = "If you are seeing this message, BioniDKU might have been interrupted while it was switching system modes and as a result, your system might start to a black screen. To resolve this issue, when you're there, press CTRL+SHIFT+ESC to open Task Manager, File > Run new task, and run `"$launcher`" from the Run box."
	Set-BootMessage $ttt $msg
} elseif ($shell -like "explorer") {
	$ttt = "Ugh, interrupted"
	$msg = "If you are seeing this message, BioniDKU has been interrupted during its execution, and your system will start to the usual (and maybe incomplete) desktop instead of the script. The script might be resumable by exiting Explorer and running `"$launcher`" from Run/CMD, but there is no guarantee it will complete the rest of the process cleanly, since it will restart from the beginning."
	Set-BootMessage $ttt $msg
}
