@description('The name of the virtual machine extension.')
param vmExtensionName string

@description('The publisher of the virtual machine extension.')
param vmExtensionPublisher string

@description('The type of the virtual machine extension.')
param vmExtensionType string

@description('The type handler version of the virtual machine extension.')
param vmExtensionTypeHandlerVersion string

@description('The auto upgrade minor version of the virtual machine extension.')
param vmExtensionAutoUpgrade bool

@description('The name of the virtual machine.')
param vmName string

@description('The location of the virtual machine.')
param Location string




@description('The name of the virtual machine to which the extension will be added.')
resource vmToDeploy_Extension 'Microsoft.Compute/virtualMachines@2022-08-01' existing = {
  name: vmName
}

@description('The virtual machine extension to be added.')
resource vmExtension_resource 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  name: vmExtensionName
  location: Location
  parent: vmToDeploy_Extension
  properties: {
    publisher: vmExtensionPublisher
    type: vmExtensionType
    typeHandlerVersion: vmExtensionTypeHandlerVersion
    enableAutomaticUpgrade: vmExtensionAutoUpgrade
    settings: {}
  }
}
