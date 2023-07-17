# PowerShell Script to set the size of pagefile.sys
# update_pagefile_size.ps1
$pagefile = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
$pagefile.AutomaticManagedPagefile = $false
#$pagefile.put() | Out-Null
Gwmi win32_pagefilesetting | where{$_.caption -like 'C:*'}
$pagefileset = Gwmi win32_pagefilesetting | where{$_.caption -like 'C:*'}
$pagefileset.InitialSize = 1024
$pagefileset.MaximumSize = 2048
$pagefileset.Put() | Out-Null

if((Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{name="C:\pagefile.sys";InitialSize = $pagefileset.InitialSize; MaximumSize = $pagefileset.MaximumSize} -EnableAllPrivileges -Verbose) -icontains "already exists"){
$pagefileset = Gwmi win32_pagefilesetting | where{$_.caption -like 'C:*'}
$pagefileset.Delete()
$pagefileset.InitialSize = 1024
$pagefileset.MaximumSize = 2048
Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{name="C:\pagefile.sys";InitialSize = $pagefileset.InitialSize; MaximumSize = $pagefileset.MaximumSize} -EnableAllPrivileges
Gwmi win32_pagefilesetting | where{$_.caption -like 'C:*'}
}
$pagefileset = Gwmi win32_pagefilesetting | where{$_.caption -like 'D:*'}
$pagefileset.InitialSize = 0
$pagefileset.MaximumSize = 0
$pagefileset.Put() | Out-Null

Gwmi win32_pagefilesetting | where{$_.caption -like 'D:*'}
Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{name="D:\pagefile.sys";InitialSize = 0; MaximumSize = 0} -EnableAllPrivileges | Out-Null

Write-host "Don't forget to reboot"
#shutdown /r /t 120 /c "rebooting to fix pagefile"