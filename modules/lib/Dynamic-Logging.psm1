# BioniDKU Logging support functions hive

function Start-Logging($module) {
	$isloggingenabled = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").Transcribe
	if ($isloggingenabled -ne 1) {return}
	
	$rid = (Get-ItemProperty -Path "HKCU:\Software\BioniDKU").ReleaseID
	$datetime = Get-Date -f 'yyyyMMddHHmmss'
	$logfilename = "BioniDKU_$rid--$module--$env:COMPUTERNAME--$datetime"
	Start-Transcript -Path "$datadir\logs\${logfilename}.txt" -IncludeInvocationHeader | Out-Null
}
function Restart-System($mr) {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 0 -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMusicStop" -Value 1 -Type DWord -Force
	if ($mr -ne "ManualExit") {Stop-Process -Name "FFPlay" -Force -ErrorAction SilentlyContinue}
	shutdown -r -t 6 -c " "
	$n = Get-Random -Minimum 1 -Maximum 6
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\ShellSpinner$n.mp4 -fs -alwaysontop -noborder"
	if ($mr -ne "ManualExit") {Start-Sleep -Seconds 1; exit}
}
