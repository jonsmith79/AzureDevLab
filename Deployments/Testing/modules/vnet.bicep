
param location string
param vnetName string
param VNetID string
//param subnets array
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
    /*subnets: [for (subnet, index) in subnets: {
      name: subnet[index]
      properties: {
        addressPrefix: '${VNetID}.${index}.0/24'
      }
    }]*/
    subnets: [
      {
        name: 'subnet1'
        properties: {
          addressPrefix: '${VNetID}.1.0/24'
        }
      }
      {
        name: 'subnet2'
        properties: {
          addressPrefix: '${VNetID}.2.0/24'
        }
      }
    ]
  }
  tags: tags
}
