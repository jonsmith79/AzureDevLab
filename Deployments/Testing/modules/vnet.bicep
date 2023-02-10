
param location string
param vnetName string
param VNetID string
param subnets array
param tags object

var vnetIPRange = '${VNetID}.0.0/16'


resource newVNet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetIPRange
      ]
    }
    subnets: [for (subnet, index) in subnets: {
      name: subnet[index]
      properties: {
        addressPrefix: '${VNetID}.${index}.0/24'
      }
    }]
  }
  tags: tags
}
