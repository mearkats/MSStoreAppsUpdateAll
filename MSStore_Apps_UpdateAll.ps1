# This script will go ahead and update all apps originating from the MS Store
# By David Mear | Jan 2023

# Exit out if the Store app is disabled
If (Test-Path -path 'HKLM:SOFTWARE\Policies\Microsoft\WindowsStore') {
	$val = (Get-ItemProperty -path 'HKLM:SOFTWARE\Policies\Microsoft\WindowsStore' -name 'RemoveWindowsStore' -erroraction SilentlyContinue).RemoveWindowsStore
	If ($val -eq 1) {
		Write-Host 'Access to the Windows Store is disabled. This script cannot continue until the Store app is allowed. Exiting.';Exit 1
	}
}

# Proceed
$result = (Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod).ReturnValue

Write-Output "The returning value of the update command was $result"

if ($result -eq 0) {
    Write-Output 'Command was accepted and executed successfully'
    Exit
} else {
    Write-Output 'Command failed to execute. Use the result above against the list of known ResultValues here:'
    Write-Output 'https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/startservice-method-in-class-win32-service'
    Exit 1
}
