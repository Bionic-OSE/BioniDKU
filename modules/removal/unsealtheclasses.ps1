# BioniDKU Registry unsealer

function Take-Permissions {
	# Developed for PowerShell 4.0 and later
	# Requires Administrator privileges
	# Links:
	#   http://shrekpoint.blogspot.ru/2012/08/taking-ownership-of-dcom-registry.html
	#   http://www.remkoweijnen.nl/blog/2012/01/16/take-ownership-of-a-registry-key-in-powershell/
	#   https://powertoe.wordpress.com/2010/08/28/controlling-registry-acl-permissions-with-powershell/
	# Some comment lines have been modified by Bionic Butter
	
	param($rootKey, $key, [System.Security.Principal.SecurityIdentifier]$sid = 'S-1-5-32-545', $recurse = $true)
	
	switch -regex ($rootKey) {
		'HKCU|HKEY_CURRENT_USER'    { $rootKey = 'CurrentUser' }
		'HKLM|HKEY_LOCAL_MACHINE'   { $rootKey = 'LocalMachine' }
		'HKCR|HKEY_CLASSES_ROOT'    { $rootKey = 'ClassesRoot' }
		'HKCC|HKEY_CURRENT_CONFIG'  { $rootKey = 'CurrentConfig' }
		'HKU|HKEY_USERS'            { $rootKey = 'Users' }
	}
	
	### Step 1 - Escalate the current session's privileges
	# Get SeTakeOwnership, SeBackup and SeRestore privileges before executes next lines, as the script needs Administrator privileges
	$import = '[DllImport("ntdll.dll")] public static extern int RtlAdjustPrivilege(ulong a, bool b, bool c, ref bool d);'
	$ntdll = Add-Type -Member $import -Name NtDll -PassThru
	$privileges = @{ SeTakeOwnership = 9; SeBackup =  17; SeRestore = 18 }
	foreach ($i in $privileges.Values) {
		$null = $ntdll::RtlAdjustPrivilege($i, 1, 0, [ref]0)
	}
	
	function Take-KeyPermissions {
		param($rootKey, $key, $sid, $recurse, $recurseLevel = 0)
	
		### Step 2 - Get ownerships of the key (works only for the current key)
		$regKey = [Microsoft.Win32.Registry]::$rootKey.OpenSubKey($key, 'ReadWriteSubTree', 'TakeOwnership')
		$acl = New-Object System.Security.AccessControl.RegistrySecurity
		$acl.SetOwner($sid)
		$regKey.SetAccessControl($acl)
	
		### Step 3 - Enable inheritance of permissions (not ownership) for the current key from parent
		$acl.SetAccessRuleProtection($false, $false)
		$regKey.SetAccessControl($acl)
	
		### Step 4 - Only for the top-level key, change permissions for the current key and propagate it for subkeys
		# To enable propagations for subkeys, it needs to execute steps 2-3 for each subkey (Step 5)
		if ($recurseLevel -eq 0) {
			$regKey = $regKey.OpenSubKey('', 'ReadWriteSubTree', 'ChangePermissions')
			$rule = New-Object System.Security.AccessControl.RegistryAccessRule($sid, 'FullControl', 'ContainerInherit', 'None', 'Allow')
			$acl.ResetAccessRule($rule)
			$regKey.SetAccessControl($acl)
		}
	
		### Step 5 - Recursively repeat steps 2-5 for every subkeys
		if ($recurse) {
			foreach($subKey in $regKey.OpenSubKey('').GetSubKeyNames()) {
				Take-KeyPermissions $rootKey ($key+'\'+$subKey) $sid $recurse ($recurseLevel+1)
			}
		}
	}
Take-KeyPermissions $rootKey $key $sid $recurse
}

# Below is one of the few chunk of codes from the original AutoIDKU script that made me 
# admire Sunryze.
#
# This modules was originally made only to remove HomeGroup, but since the vast majority of
# it only takes care of the permission seal on the related registry keys, and I also need
# to remove Quick Access on 1511- using this method as well, this has been repurposed to be
# the "caretaker" of the sealed registry keys.
# One important change I made to original code is change from HKCR to HKLM\SOFTWARE\Classes,
# as changes to HKLM takes effect on HKCR as well, and works for all users.
#
# Commented lines with "[Sunryze]" after the "#"s are from them, and "[Bionic]"s are from me

# =========================================================================================
#[Sunryze] Administrators group 'S-1-5-32-544'
#[Bionic] Here was supposed to be the Take-KeyPermissions part, but I moved it down to the foreach loop
#[Sunryze] create a link to Hkey_classes_root
#if (-not (test-path hkcr:\)) {New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT} #[Bionic] The old HKCR line
#[Sunryze] create new registry access rule to add to the ACL
$SystemRights = [System.Security.AccessControl.RegistryRights]::ReadKey
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]'ContainerInherit, ObjectInherit'
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::NoPropagateInherit
$AccessControlType =[System.Security.AccessControl.AccessControlType]::Allow
$Account = New-Object System.Security.Principal.NTAccount('BuiltIn\Administrators')
$RegistryZipUsersRule = New-Object System.Security.AccessControl.RegistryAccessRule($Account, $SystemRights, $InheritanceFlag, $PropagationFlag, $AccessControlType)
#[Bionic] Storing some key paths as variables so we don't have to repeat them
$clsid = "SOFTWARE\Classes\CLSID"
$ns = "Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"
$homegroup = "{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}"
$qa = "{679f85cb-0220-4080-b29b-5540cc05aab6}"
#[Sunryze] List of registry keys to change
$keylist = @("$clsid\$homegroup", #[Bionic] HomeGroup
			"$clsid\$homegroup\ShellFolder",
			"SOFTWARE\$ns\$homegroup",
			"SOFTWARE\WOW6432Node\$ns\$homegroup",
			"$clsid\$qa", #[Bionic] The ones for QA on 1511-
			"$clsid\$qa\ShellFolder")
#[Sunryze] disable inheritance, remove users, add zip_users for each registry key
foreach ($key in $keylist) {
	Take-Permissions 'HKLM' "$key" 'S-1-5-32-544' $true
	$fullkey = "HKLM:\$key"
	$thisacl = Get-Acl -path $fullkey
	$thisacl.SetAccessRuleProtection($true,$true)  #[Sunryze] this removes inheritance
	$thisacl | Set-Acl -path $fullkey  #[Sunryze] write it back
	$thisacl = Get-Acl -path $fullkey  #[Sunryze] get it again as the inheritance rules must match or it won't take additional commands
	$userkeys = $thisacl.Access | Where-Object {$_.IdentityReference.value.Contains('BUILTIN\Users')}  #[Sunryze] get a list of rules to remove
	foreach ($ukey in $userkeys) {$thisacl.RemoveAccessRule($ukey)}  #[Sunryze] remove rules from list
	#$thisacl.RemoveAccessRuleAll($builtinusers)     #[Sunryze] I could not get removeaccessruleall to work for builtin account
	$thisacl.AddAccessRule($RegistryZipUsersRule)    #[Sunryze] add the new rule
	$thisacl | Set-Acl -path $fullkey                #[Sunryze] write back changes.
}
# =========================================================================================
# With the permission seal out of the way, we can now DESTROY those keys later. Thanks Sunryze once again for the code!
