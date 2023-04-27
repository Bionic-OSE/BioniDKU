# Bionic note: This doesn't seem to work reliably and it seems really complicated.
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing HomeGroup" -n; Write-Host ([char]0xA0)

function Take-Permissions {
    # Developed for PowerShell v4.0
    # Required Admin privileges
    # Links:
    #   http://shrekpoint.blogspot.ru/2012/08/taking-ownership-of-dcom-registry.html
    #   http://www.remkoweijnen.nl/blog/2012/01/16/take-ownership-of-a-registry-key-in-powershell/
    #   https://powertoe.wordpress.com/2010/08/28/controlling-registry-acl-permissions-with-powershell/

    param($rootKey, $key, [System.Security.Principal.SecurityIdentifier]$sid = 'S-1-5-32-545', $recurse = $true)

    switch -regex ($rootKey) {
        'HKCU|HKEY_CURRENT_USER'    { $rootKey = 'CurrentUser' }
        'HKLM|HKEY_LOCAL_MACHINE'   { $rootKey = 'LocalMachine' }
        'HKCR|HKEY_CLASSES_ROOT'    { $rootKey = 'ClassesRoot' }
        'HKCC|HKEY_CURRENT_CONFIG'  { $rootKey = 'CurrentConfig' }
        'HKU|HKEY_USERS'            { $rootKey = 'Users' }
    }

    ### Step 1 - escalate current process's privilege
    # get SeTakeOwnership, SeBackup and SeRestore privileges before executes next lines, script needs Admin privilege
    $import = '[DllImport("ntdll.dll")] public static extern int RtlAdjustPrivilege(ulong a, bool b, bool c, ref bool d);'
    $ntdll = Add-Type -Member $import -Name NtDll -PassThru
    $privileges = @{ SeTakeOwnership = 9; SeBackup =  17; SeRestore = 18 }
    foreach ($i in $privileges.Values) {
        $null = $ntdll::RtlAdjustPrivilege($i, 1, 0, [ref]0)
    }

    function Take-KeyPermissions {
        param($rootKey, $key, $sid, $recurse, $recurseLevel = 0)

        ### Step 2 - get ownerships of key - it works only for current key
        $regKey = [Microsoft.Win32.Registry]::$rootKey.OpenSubKey($key, 'ReadWriteSubTree', 'TakeOwnership')
        $acl = New-Object System.Security.AccessControl.RegistrySecurity
        $acl.SetOwner($sid)
        $regKey.SetAccessControl($acl)

        ### Step 3 - enable inheritance of permissions (not ownership) for current key from parent
        $acl.SetAccessRuleProtection($false, $false)
        $regKey.SetAccessControl($acl)

        ### Step 4 - only for top-level key, change permissions for current key and propagate it for subkeys
        # to enable propagations for subkeys, it needs to execute Steps 2-3 for each subkey (Step 5)
        if ($recurseLevel -eq 0) {
            $regKey = $regKey.OpenSubKey('', 'ReadWriteSubTree', 'ChangePermissions')
            $rule = New-Object System.Security.AccessControl.RegistryAccessRule($sid, 'FullControl', 'ContainerInherit', 'None', 'Allow')
            $acl.ResetAccessRule($rule)
            $regKey.SetAccessControl($acl)
        }

        ### Step 5 - recursively repeat steps 2-5 for subkeys
        if ($recurse) {
            foreach($subKey in $regKey.OpenSubKey('').GetSubKeyNames()) {
                Take-KeyPermissions $rootKey ($key+'\'+$subKey) $sid $recurse ($recurseLevel+1)
            }
        }
    }
Take-KeyPermissions $rootKey $key $sid $recurse
}

#administrators group 'S-1-5-32-544'
#Take-KeyPermissions $rootKey $key $sid $recurse
Take-Permissions 'HKCR' 'CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}' 'S-1-5-32-544' $true
Take-Permissions 'HKCR' 'CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder' 'S-1-5-32-544' $true
#create a link to Hkey_classes_root
if (-not (test-path hkcr:\)) {New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT}
#create new registry access rule to add to the ACL
$SystemRights = [System.Security.AccessControl.RegistryRights]::ReadKey
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]'ContainerInherit, ObjectInherit'
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::NoPropagateInherit
$AccessControlType =[System.Security.AccessControl.AccessControlType]::Allow
$Account = New-Object System.Security.Principal.NTAccount('BuiltIn\Administrators')
$RegistryZipUsersRule = New-Object System.Security.AccessControl.RegistryAccessRule($Account, $SystemRights, $InheritanceFlag, $PropagationFlag, $AccessControlType)
# List of registry keys to change
$keylist = @('HKCR:\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}',
             'HKCR:\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder')

#disable inheritance, remove users, add zip_users for each registry key
foreach ($key in $keylist) {
    $thisacl = Get-Acl -path $key
    $thisacl.SetAccessRuleProtection($true,$true)  #this removes inheritance
    $thisacl | Set-Acl -path $key  #write it back
    $thisacl = Get-Acl -path $key  #get it again as the inheritance rules must match or it won't take additional commands
    $userkeys = $thisacl.Access | Where-Object {$_.IdentityReference.value.Contains('BUILTIN\Users')}  #get a list of rules to remove
    foreach ($ukey in $userkeys) {$thisacl.RemoveAccessRule($ukey)}  #remove rules from list
    #$thisacl.RemoveAccessRuleAll($builtinusers)     # I could not get removeaccessruleall to work for builtin account
    $thisacl.AddAccessRule($RegistryZipUsersRule)    #add the new rule
    $thisacl | Set-Acl -path $key                    #write back changes.
}
