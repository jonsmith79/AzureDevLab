
param location string
param vnetName string
param VNetID string
param subnets array
param tags object

var vnetIPRange = '${VNetID}.0.0/16'
var subnetArray = [for (subnet, index) in subnets: {
  name: subnet
  prefix: '${VNetID}.${index}.0/24'
}]

resource newVNet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetIPRange
      ]
    }
    subnets: [for subnet in subnetArray: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.prefix
      }
    }]
  }
  tags: tags
}
