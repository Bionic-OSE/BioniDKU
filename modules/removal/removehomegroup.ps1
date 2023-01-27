# Bionic note: This is not working and it seems really complicated.

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing HomeGroup" -n; Write-Host ([char]0xA0)
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
