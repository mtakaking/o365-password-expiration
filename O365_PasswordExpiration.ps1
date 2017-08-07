
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Connect-MsolService -Credential $UserCredential

$staffToEmail = Get-MsolUser -all | Where-Object {$_.isLicensed -eq $true -and $_.Licenses[0].ServiceStatus[8].ProvisioningStatus -eq "Disabled"} | select DisplayName, userprincipalname, LastPasswordChangeTimeStamp,@{Name=”PasswordAge”;Expression={(Get-Date)-$_.LastPasswordChangeTimeStamp}} | where {$_.PasswordAge -le “89” -and $_.PasswordAge -gt "80"} | sort-object PasswordAge -descending
$staffToEmail | Export-Csv -Path C:\Users\$env:username\Desktop\O365_PasswordExpiration.csv -NoTypeInformation