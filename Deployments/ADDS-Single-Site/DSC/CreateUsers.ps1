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
        [String]$ADDSNetBiosDomain,
        [System.Management.Automation.PSCredential]$ADDSUserCreds
        #[Array]$ADDSUsers
    )

    Import-DscResource -Module ActiveDirectoryDsc
$ADDSUsers = @(
  [pscustomobject]@{
    fname = 'Adele';
    sname = 'Vance';
    uname = 'AdeleV';
    job = 'Retail Manager';
    dept = 'Retail';
    manager = 'MiriamG';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Adele%20Vance.jpeg'
  }
  [pscustomobject]@{
    fname = 'Alex';
    sname = 'Wilber';
    uname = 'AlexW';
    job = 'Marketing Assistant';
    dept = 'Marketing';
    manager = 'MiriamG';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Alex%20Wilber.jpeg'
  }
  [pscustomobject]@{
    fname = 'Allan';
    sname = 'Deyoung';
    uname = 'AllanD';
    job = 'IT Admin';
    dept = 'IT';
    manager = 'NestorW';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Allan%20Deyoung.jpeg'
  }
  [pscustomobject]@{
    fname = 'Christie';
    sname = 'Cline';
    uname = 'ChristieC';
    job = 'Buyer';
    dept = 'Sales';
    manager = 'MiriamG';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Christie%20Cline.jpeg'
  }
  [pscustomobject]@{
    fname = 'Debra';
    sname = 'Berger';
    uname = 'DebraB';
    job = 'Administrative Assistant';
    dept = 'Executive Management';
    manager = 'PattiF';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Debra%20Berger.jpeg'
  }
  [pscustomobject]@{
    fname = 'Diego';
    sname = 'Siciliani';
    uname = 'DiegoS';
    job = 'HR Manager';
    dept = 'HR';
    manager = 'NestorW';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Diego%20Siciliani.jpeg'
  }
  [pscustomobject]@{
    fname = 'Emily';
    sname = 'Braun';
    uname = 'EmilyB';
    job = 'Budget Analyst';
    dept = 'Finance';
    manager = 'NestorW';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Emily%20Braun.jpeg'
  }
  [pscustomobject]@{
    fname = 'Grady';
    sname = 'Archie';
    uname = 'GradyA';
    job = 'Designer';
    dept = 'R&D';
    manager = 'NestorW';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Grady%20Archie.jpeg'
  }
  [pscustomobject]@{
    fname = 'Henrietta';
    sname = 'Mueller';
    uname = 'HenriettaM';
    job = 'Developer';
    dept = 'R&D';
    manager = 'NestorW';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Henrietta%20Meuller.jpeg'
  }
  [pscustomobject]@{
    fname = 'Isaiah';
    sname = 'Langer';
    uname = 'IsaiahL';
    job = 'Sales Representative';
    dept = 'Sales';
    manager = 'MiriamG';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Isaiah%20Langer.jpeg'
  }
  [pscustomobject]@{
    fname = 'Johanna';
    sname = 'Lorenz';
    uname = 'JohannaL';
    job = 'Senior Engineer';
    dept = 'Engineering';
    manager = 'LidiaH';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Johanna%20Lorenz.jpeg'
  }
  [pscustomobject]@{
    fname = 'Joni';
    sname = 'Sherman';
    uname = 'JoniS';
    job = 'Paralegal';
    dept = 'Legal';
    manager = 'PattiF';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Joni%20Sherman.jpeg'
  }
  [pscustomobject]@{
    fname = 'Lee';
    sname = 'Gu';
    uname = 'LeeG';
    job = 'Director';
    dept = 'Manufacturing';
    manager = 'PattiF';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Lee%20Gu.jpeg'
  }
  [pscustomobject]@{
    fname = 'Lidia';
    sname = 'Holloway';
    uname = 'LidiaH';
    job = 'Product Manager';
    dept = 'Engineering';
    manager = 'NestorW';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Lidia%20Holloway.jpeg'
  }
  [pscustomobject]@{
    fname = 'Lynne';
    sname = 'Robbins';
    uname = 'LynneR';
    job = 'Planner';
    dept = 'Retail';
    manager = 'MiriamG';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Lynne%20Robbins.jpeg'
  }
  [pscustomobject]@{
    fname = 'Megan';
    sname = 'Bowen';
    uname = 'MeganB';
    job = 'Marketing Manager';
    dept = 'Marketing';
    manager = 'MiriamG';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Megan%20Bowen.jpeg'
  }
  [pscustomobject]@{
    fname = 'Miriam';
    sname = 'Graham';
    uname = 'MiriamG';
    job = 'Chief Marketing Officer';
    dept = 'Sales & Marketing';
    manager = 'PattiF';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Miriam%20Graham.jpeg'
  }
  [pscustomobject]@{
    fname = 'Nestor';
    sname = 'Wilke';
    uname = 'NestorW';
    job = 'Director';
    dept = 'Operations';
    manager = 'PattiF';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Nestor%20Wilke.jpeg'
  }
  [pscustomobject]@{
    fname = 'Patti';
    sname = 'Fernandez';
    uname = 'PattiF';
    job = 'President';
    dept = 'Executive Management';
    manager = '';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Patti%20Fernandez.jpeg'
  }
  [pscustomobject]@{
    fname = 'Pradeep';
    sname = 'Gupta';
    uname = 'PradeepG';
    job = 'Accountant';
    dept = 'Finance';
    manager = 'NestorW';
    thumbnail = 'https://raw.githubusercontent.com/jonsmith79/AzureDevLab/main/Deployments/xx_Images/avatars/Pradeep%20Gupta.jpeg'
  }
)
    Node localhost
    {
        for($i=0; $i -lt $ADDSUsers.Length; $i++)
        {
            
            #$Password = ConvertTo-SecureString -String $ADDSUserPassword -AsPlainText -Force
            [System.Management.Automation.PSCredential]$DomainCreds = New-Object System.Management.Automation.PSCredential ("$($ADDSNetBiosDomain)\$($ADDSUsers[$i].uname)", $ADDSUserCreds.Password)
            ADUser "$($ADDSNetBiosDomain)\$($ADDSUsers[$i].UserName)"
            {
                Ensure              = 'Present'
                UserName            = $ADDSUsers[$i].uname
                GivenName           = $ADDSUsers[$i].fname
                Surname             = $ADDSUsers[$i].sname
                DisplayName         = "$($ADDSUsers[$i].fname) $($ADDSUsers[$i].sname)"
                Description         = $ADDSUsers[$i].Description
                EmailAddress        = "$($ADDSUsers[$i].uname)@$($ADDSDomain)"
                UserPrincipalName   = "$($ADDSUsers[$i].uname)@$($ADDSDomain)"
                Password            = $DomainCreds
                ThumbnailPhoto      = $ADDSUsers[$i].thumbnail
                Manager             = $ADDSUsers[$i].manager
                JobTitle            = $ADDSUsers[$i].job
                Department          = $ADDSUsers[$i].dept
                PasswordNeverResets = $true
                PasswordNeverExpires = $true
                DomainName          = $ADDSDomain
                Enabled             = $true
                Path                = "OU=Users,OU=Accounts,$($ADDSBaseDN)"
            }
        }
    }
}