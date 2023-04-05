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
        ADDSUserCreds: {
          UserName: 'username'
          Password: 'PrivateSettingsRef:UserPassword'
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
