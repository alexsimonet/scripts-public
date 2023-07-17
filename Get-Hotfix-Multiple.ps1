get-content C:\temp\DC.txt |
  Where {$_ -AND (Test-Connection $_ -Quiet)} |
    foreach { 
      Get-Hotfix -Credential bws\as_da -computername $_ |
        Select CSName,Description,HotFixID,InstalledBy,InstalledOn |
          Export-CSV -Append "C:\temp\DC-Get-Hotfix.csv" 
          }
