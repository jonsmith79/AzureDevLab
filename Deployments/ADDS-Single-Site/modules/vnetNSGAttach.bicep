//===================
// Parameters section
//===================

@description('Name of the VNet the subnet is attached to.')
param vnetName string

@description('Name of the Subnet to attach to.')
param subnetName string

@description('Name of the NSG to attach.')
param nsgName string

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

/*
// Variable to add new NSG to subnet
var addPropertyNSG = {
  networkSecurityGroup: {
    id: getNSG.id
  }
}

// Join the exiting and new properties
var newProperties = union(getSubnet.properties, addPropertyNSG)
*/

// Get the existing subnet address prefix
var subnetAddressPrefix = getSubnet.properties.addressPrefix

// Re-deploy subnet with new NSG included onto existing properties
resource updateSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: getSubnet.name
  parent: getVNet
  properties: {
    addressPrefix: subnetAddressPrefix
    networkSecurityGroup: {
      id: getNSG.id
    }
  }
  dependsOn: [
    getSubnet
    getNSG
  ]
}
