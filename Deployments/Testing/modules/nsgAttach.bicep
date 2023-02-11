
param VNet string
param subnet string
param nsg string

resource existingVNet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: VNet
}

resource existingSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: subnet
}

resource existingNSG 'Microsoft.Network/networkSecurityGroups@2022-07-01' existing = {
  name: nsg
}

resource updateSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: existingSubnet.name
  parent: existingVNet
  properties: {
    addressPrefix: existingSubnet.properties.addressPrefix
    networkSecurityGroup: {
      id: existingNSG.id
    }
  }
  dependsOn: [
    existingSubnet
    existingNSG
  ]
}


output vnetName string = existingVNet.name
output subnetName string = existingSubnet.name
output nsgName string = existingNSG.name
