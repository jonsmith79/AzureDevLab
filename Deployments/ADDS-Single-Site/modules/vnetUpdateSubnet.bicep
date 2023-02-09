//===================
// Parameters section
//===================

@description('Name of the VNet the subnet is attached to.')
param vnetName string

@description('Name of the Subnet to attach to.')
param subnetName string

@description('Union of the existing properties and the new NSG to attach to the subnet.')
param properties object

//==================
// Variables section
//==================


//==================
// Resources section
//==================

resource updateSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${vnetName}/${subnetName}'
  properties: properties
}

