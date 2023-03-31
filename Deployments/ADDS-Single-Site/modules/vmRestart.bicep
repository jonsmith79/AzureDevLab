/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/

@description('VM Name')
param vmName string

@description('Location of VM')
param Location string

@description('Artifacts location')
param artifactsLocation string

@description('Artifacts location SaS Token')
@secure()
param artifactsLocationSasToken string

/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/

var ModulesURL = uri(artifactsLocation, 'DSC/RESTARTVM.zip${artifactsLocationSasToken}')
var ConfigurationFunction = 'RESTARTVM.ps1\\RESTARTVM'

/*-------------------------------------------------------------------------------------------
  Resources section
-------------------------------------------------------------------------------------------*/

resource vmName_Microsoft_PowerShell_DSC 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = {
  name: '${vmName}/Microsoft.PowerShell.DSC'
  location: Location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.83'
    autoUpgradeMinorVersion: true
    settings: {
      modulesUrl: ModulesURL
      configurationFunction: ConfigurationFunction
    }
  }
}

/*-------------------------------------------------------------------------------------------
  Outputs section
-------------------------------------------------------------------------------------------*/
