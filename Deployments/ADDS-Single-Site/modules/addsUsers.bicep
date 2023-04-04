/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/
@description('Virtual Machine Name')
param vmName string

@description('Location of the resources')
param Location string

@description('Base Domain Name')
param ADDSBaseDN string

@description('Domain Name')
param ADDSDomain string

@description('Domain NetBIOS Name')
param ADDSNetBiosDomain string

@description('User Password')
@secure()
param ADDSUserPassword string

@description('Artifacts Location')
param artifactsLocation string

@description('Artifacts Location Sas Token')
@secure()
param artifactsLocationSasToken string
/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/
var ADDSUsers = [
  {
    fname: 'Adele'
    sname: 'Vance'
    uname: 'AdeleV'
    job: 'Retail Manager'
    dept: 'Retail'
    manager: 'MiriamG'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Adele%20Vance.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Alex'
    sname: 'Wilber'
    uname: 'AlexW'
    job: 'Marketing Assistant'
    dept: 'Marketing'
    manager: 'MiriamG'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Alex%20Wilber.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Allan'
    sname: 'Deyoung'
    uname: 'AllanD'
    job: 'IT Admin'
    dept: 'IT'
    manager: 'NestorW'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Allan%20Deyoung.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Christie'
    sname: 'Cline'
    uname: 'ChristieC'
    job: 'Buyer'
    dept: 'Sales'
    manager: 'MiriamG'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Christie%20Cline.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Debra'
    sname: 'Berger'
    uname: 'DebraB'
    job: 'Administrative Assistant'
    dept: 'Executive Management'
    manager: 'PattiF'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Debra%20Berger.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Diego'
    sname: 'Siciliani'
    uname: 'DiegoS'
    job: 'HR Manager'
    dept: 'HR'
    manager: 'NestorW'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Diego%20Siciliani.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Emily'
    sname: 'Braun'
    uname: 'EmilyB'
    job: 'Budget Analyst'
    dept: 'Finance'
    manager: 'NestorW'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Emily%20Braun.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Grady'
    sname: 'Archie'
    uname: 'GradyA'
    job: 'Designer'
    dept: 'R&D'
    manager: 'NestorW'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Grady%20Archie.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Henrietta'
    sname: 'Mueller'
    uname: 'HenriettaM'
    job: 'Developer'
    dept: 'R&D'
    manager: 'NestorW'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Henrietta%20Meuller.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Isaiah'
    sname: 'Langer'
    uname: 'IsaiahL'
    job: 'Sales Representative'
    dept: 'Sales'
    manager: 'MiriamG'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Isaiah%20Langer.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Johanna'
    sname: 'Lorenz'
    uname: 'JohannaL'
    job: 'Senior Engineer'
    dept: 'Engineering'
    manager: 'LidiaH'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Johanna%20Lorenz.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Joni'
    sname: 'Sherman'
    uname: 'JoniS'
    job: 'Paralegal'
    dept: 'Legal'
    manager: 'PattiF'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Joni%20Sherman.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Lee'
    sname: 'Gu'
    uname: 'LeeG'
    job: 'Director'
    dept: 'Manufacturing'
    manager: 'PattiF'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Lee%20Gu.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Lidia'
    sname: 'Holloway'
    uname: 'LidiaH'
    job: 'Product Manager'
    dept: 'Engineering'
    manager: 'NestorW'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Lidia%20Holloway.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Lynne'
    sname: 'Robbins'
    uname: 'LynneR'
    job: 'Planner'
    dept: 'Retail'
    manager: 'MiriamG'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Lynne%20Robbins.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Megan'
    sname: 'Bowen'
    uname: 'MeganB'
    job: 'Marketing Manager'
    dept: 'Marketing'
    manager: 'MiriamG'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Megan%20Bowen.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Miriam'
    sname: 'Graham'
    uname: 'MiriamG'
    job: 'Chief Marketing Officer'
    dept: 'Sales & Marketing'
    manager: 'PattiF'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Miriam%20Graham.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Nestor'
    sname: 'Wilke'
    uname: 'NestorW'
    job: 'Director'
    dept: 'Operations'
    manager: 'PattiF'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Nestor%20Wilke.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Patti'
    sname: 'Fernandez'
    uname: 'PattiF'
    job: 'President'
    dept: 'Executive Management'
    manager: ''
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Patti%20Fernandez.jpeg${artifactsLocationSasToken}')
  }
  {
    fname: 'Pradeep'
    sname: 'Gupta'
    uname: 'PradeepG'
    job: 'Accountant'
    dept: 'Finance'
    manager: 'NestorW'
    thumbnail: uri(artifactsLocation, 'xx_Images/avatars/Pradeep%20Gupta.jpeg${artifactsLocationSasToken}')
  }
]

var ModulesURL = uri(artifactsLocation, 'DSC/CreateUsers.zip${artifactsLocationSasToken}')
var ConfigurationFunction = 'CreateUsers.ps1\\CreateUsers'

/*-------------------------------------------------------------------------------------------
  Resources section
-------------------------------------------------------------------------------------------*/
resource vmName_Microsoft_PowerShell_DSC 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = {
  name: '${vmName}/Microsoft.Powershell.DSC'
  location: Location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.83'
    autoUpgradeMinorVersion: true
    settings: {
      modulesUrl: ModulesURL
      ConfigurationFunction: ConfigurationFunction
      Properties: {
        ADDSBaseDN: ADDSBaseDN
        ADDSDomain: ADDSDomain
        ADDSNetBiosDomain: ADDSNetBiosDomain
        ADDSUsers: ADDSUsers
        ADDSUserCreds: {
          username: 'username'
          password: 'PrivateSettingsRef:ADDSUserPassword'
        }
      }
    }
    protectedSettings: {
      Items: {
        UserPassword: ADDSUserPassword
      }
    }
  }
}
/*-------------------------------------------------------------------------------------------
  Outputs section
-------------------------------------------------------------------------------------------*/
