//===================
// Parameters section
//===================

@description('Name of the resource group the resource belong.')
param rgName string

@description('Name of the VNet the subnet is attached to.')
param vnetName string

@description('Name of the Subnet to attach to.')
param subnetName string

@description('Name of the NSG to attach.')
param nsgName string

/*
@description('Properties of the Subnet.')
param properties object
*/


//==================
// Variables section
//==================



//==================
// Resrouces section
//==================

// Get VNet of the subnet
resource getVNet 'Microsoft.Network/virtualNetworks@2021-02-01' existing ={
  name: vnetName
}

// Get Tier0Infra Subnet
resource getSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name: subnetName
}

// Get ADDS NSG
resource getNSG 'Microsoft.Network/networkSecurityGroups@2021-02-01' existing = {
  name: nsgName
}

resource updateSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${getVNet.name}/${getSubnet.name}'
  properties: union(getSubnet.properties, {
    networkSecurityGroup: {
      id: getNSG.id
    }
  })
  dependsOn: [
    getVNet
    getSubnet
    getNSG
  ]
}
