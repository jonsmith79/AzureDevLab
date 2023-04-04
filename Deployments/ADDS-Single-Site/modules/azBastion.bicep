@description('Public IP Address Name')
param PIPAddressName string

@description('Public IP Allocation Method')
param PIPAllocationMethod string

@description('Existing VNet Name')
param BastionVNetName string

@description('Existing Subnet Name')
param SubnetName string

@description('Region of Resource')
param Location string

resource PIPAddressName_resource 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: PIPAddressName
  location: Location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: PIPAllocationMethod
  }
}

resource VNetName_resource 'Microsoft.Network/bastionHosts@2022-07-01' = {
  name: BastionVNetName
  location: Location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', BastionVNetName, SubnetName)
          }
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', PIPAddressName)
          }
        }
      }
    ]
  }
  dependsOn: [
    PIPAddressName_resource
  ]
}
