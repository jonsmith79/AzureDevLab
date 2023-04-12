//===================
// Parameters section
//===================
@description('Virtual Network Name') 
param VirtualNetworkName string 

@description('Virtual Network Address Prefix') 
param VirtualNetworkAddressPrefix string

@description('Virtual Network Subnets')
param Subnets array

@description('Resource Location')
param Location string

@description('NSG ID')
param nsgID string

//==================
// Variables section
//==================
var VNetIPRange = '${VirtualNetworkAddressPrefix}.0.0/16'

//==================
// Resources section
//==================

// Create the Virtual Network (VNet) and all associated subnets
resource newVNet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: VirtualNetworkName
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        VNetIPRange
      ]
    }
    subnets: [for (subnet, i) in Subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnet
        networkSecurityGroup: (subnet.name == Subnets[2].name) ? {
          id: nsgID
        } : null
      } 
    }]
  }
}


//=================
// Output's section
//=================
output VNetObject object = newVNet
output VNet1ObjectID string = newVNet.id
