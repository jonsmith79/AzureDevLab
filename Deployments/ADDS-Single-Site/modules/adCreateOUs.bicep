/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/
@description('Computer Name')
param computerName string

@description('Location of resources')
param Location string

@description('Base Domain Name')
param BaseDN string

@description('Artifacts Location')
param artifactsLocation string

@description('Artifacts Location Sas Token')
@secure()
param artifactsLocationSasToken string

/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/
var ModulesURL = uri(artifactsLocation, 'DSC/CREATEOUS.zip${artifactsLocationSasToken}')
var ConfigurationFunction = 'CREATEOUS.ps1\\CREATEOUS'

/*-------------------------------------------------------------------------------------------
  Resources section
-------------------------------------------------------------------------------------------*/
resource computerName_Microsoft_PowerShell_DSC 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = {
  name: '${computerName}/Microsoft.Powershell.DSC'
  location: Location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.83'
    autoUpgradeMinorVersion: true
    settings: {
      ModulesUrl: ModulesURL
      ConfigurationFunction: ConfigurationFunction
      Properties: {
        BaseDN: BaseDN
      }
    }
  }
}

/*-------------------------------------------------------------------------------------------
  Outputs section
-------------------------------------------------------------------------------------------*/
