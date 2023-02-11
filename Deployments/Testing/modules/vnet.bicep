
param location string
param vnetName string
param VNetID string
param subnets array
param nsgID string
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
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.prefix
        networkSecurityGroup: (subnet.name == subnets[2].name) ? {
          id: nsgID
        } : null
      }
    }]
  }
  tags: tags
}
