// main.bicep

param nsgName string = 'thomastest-nsg2'
param vnetName string = 'thomastest-vnet'
param subnetName string = 'subnet1'

// Reference to nsg
resource nsg 'Microsoft.Network/networkSecurityGroups@2022-01-01' existing = {
  name: nsgName
}

// Get existing subnet
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' existing = {
  name: '${vnetName}/${subnetName}'
}

// Update the subnet
module attachNsg 'xModule_updateSubnet.bicep' = {
  name: 'update-vnet-subnet-${vnetName}-${subnetName}'
  params: {
    vnetName: vnetName
    subnetName: subnetName
    // Update the nsg
    properties: union(subnet.properties, {
      networkSecurityGroup: {
        id: nsg.id
      }
    })
  }
}
