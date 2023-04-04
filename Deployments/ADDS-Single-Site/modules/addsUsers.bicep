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
        ADDSUsers: ADDSUsers
        ADDSUserPassword: 'PrivateSettingsRef:UserPassword'
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
