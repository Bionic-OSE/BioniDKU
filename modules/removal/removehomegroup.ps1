Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Trying to remove HomeGroup"
# With the permission seal removed earlier, DESTROY the keys
$clsid = "SOFTWARE\Classes\CLSID"
$ns = "Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"
$homegroup = "{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}"
$byekeys = @("$clsid\$homegroup",
	"$clsid\$homegroup\ShellFolder",
	"SOFTWARE\$ns\$homegroup",
	"SOFTWARE\WOW6432Node\$ns\$homegroup")
foreach ($keys in $byekeys) {
	Remove-Item "HKLM:\$keys" -Recurse -Force -ErrorAction SilentlyContinue
}
# Then, we need to disable the services.
Stop-Service -Name HomeGroupProvider
Stop-Service -Name HomeGroupListener
Start-Process sc.exe -Wait -NoNewWindow -ArgumentList "config HomeGroupProvider start= DISABLED"
Start-Process sc.exe -Wait -NoNewWindow -ArgumentList "config HomeGroupListener start= DISABLED"
# If we're lucky, the folder should be gone completely, but if not, then Winaero is the only way