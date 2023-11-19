# BioniDKU system files ownership taking & removal functions hive

function Grant-Ownership($itemtype,$item) {
	switch ($itemtype) {
		"F" {$itemtarg, $itemiarg = $null, $null}
		"D" {$itemtarg, $itemiarg = "/r", "/t"}
	}
	Start-Process takeown.exe -Wait -NoNewWindow -ArgumentList "/f `"$item`" $itemtarg"
	Start-Process icacls.exe -Wait -NoNewWindow -ArgumentList "`"$item`" /grant Administrators:F $itemiarg"
}
function Remove-SystemFile($itemtype,$item) {
	Grant-Ownership $itemtype $item
	switch ($itemtype) {
		"F" {Remove-Item -Path "$item" -Force -ErrorAction SilentlyContinue}
		"D" {Remove-Item -Path "$item" -Force -Recurse -ErrorAction SilentlyContinue}
	}
}
