<#PSScriptInfo
.VERSION 1.0.1
.GUID 3bf5100b-238e-435a-8a98-67d756c5cdeb
.AUTHOR DSC Community
.COMPANYNAME DSC Community
.COPYRIGHT DSC Community contributors. All rights reserved.
.TAGS DSCConfiguration
.LICENSEURI https://github.com/dsccommunity/ActiveDirectoryDsc/blob/main/LICENSE
.PROJECTURI https://github.com/dsccommunity/ActiveDirectoryDsc
.ICONURI https://dsccommunity.org/images/DSC_Logo_300p.png
.RELEASENOTES
Updated author, copyright notice, and URLs.
#>

#Requires -Module ActiveDirectoryDsc

<#
    .DESCRIPTION
        This configuration will create a user with a password and then ignore
        when the password has changed. This might be used with a traditional
        user account where a managed password is not desired.
#>

configuration CreateUsers
{
   param
    (
        [String]$ADDSBaseDN,
        [String]$ADDSDomain,
        [System.Management.Automation.PSCredential]$ADDSUserPassword,
        [Array]$ADDSUsers
    )

    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        foreach($User in $ADDSUsers)
        {
            $i = 0
            #$Password = ConvertTo-SecureString -String $ADDSUserPassword -AsPlainText -Force
            ADUser $User[$i].UserName
            {
                Ensure              = 'Present'
                UserName            = $User[$i].uname
                GivenName           = $User[$i].fname
                Surname             = $User[$i].sname
                DisplayName         = "$($User[$i].fname) $($User[$i].sname)"
                Description         = $User[$i].Description
                EmailAddress        = "$($User[$i].uname)@$($ADDSDomain)"
                UserPrincipalName   = "$($User[$i].uname)@$($ADDSDomain)"
                Password            = $ADDSUserPassword
                ThumbnailPhoto      = $User[$i].thumbnail
                Manager             = $User[$i].manager
                JobTitle            = $User[$i].job
                Department          = $User[$i].dept
                PasswordNeverResets = $true
                DomainName          = $ADDSDomain
                Enabled             = $true
                Path                = "OU=Users,OU=Accounts,$($ADDSBaseDN)"
            }
            $i++
        }
    }
}