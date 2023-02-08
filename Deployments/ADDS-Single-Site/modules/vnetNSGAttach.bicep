//===================
// Parameters section
//===================

@description('Name of the NSG to attach.')
param nsgName string

@description('Name of the VNet the subnet is attached to.')
param vnetName string

@description('Name of the Subnet to attach to.')
param subnetName string
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

// Get Tier0Infra Subnet
resource subnetADDS_get 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name: '${vnetName}/${subnetName}'
}

// Get ADDS NSG
resource nsgADDS_get 'Microsoft.Network/networkSecurityGroups@2021-02-01' existing = {
  name: nsgName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: subnetName
  properties: union(subnetADDS_get.properties, {
    networkSecurityGroup: {
      id: nsgADDS_get.id
    }
  })
}
