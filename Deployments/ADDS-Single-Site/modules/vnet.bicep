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


//==================
// Variables section
//==================
var VNetIPRange = '${VirtualNetworkAddressPrefix}.0.0/16'

//==================
// Resrouces section
//==================

// Create the Virtual Network (VNet) and all associated subnets
resource VirtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: VirtualNetworkName
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        VNetIPRange
      ]
    }
    subnets: [for (SubnetName, i) in Subnets: {
      name: SubnetName
      /* properties: (SubnetName == '${VirtualNetworkName}-Subnet-Tier0Infra' ? {
        addressPrefix: '${VirtualNetworkAddressPrefix}.${i}.0/24'
        networkSecurityGroups: {
          id: nsgName
        }
      } : {
        addressPrefix: '${VirtualNetworkAddressPrefix}.${i}.0/24'
      })*/
      properties: {
        addressPrefix: '${VirtualNetworkAddressPrefix}.${i}.0/24'
      } 
    }]
  }
}


//=================
// Output's section
//=================
output DeployedSubnets array = [for i in range(0, length(Subnets)): {
  name: Subnets[i]
  id: VirtualNetworkName_resource.properties.subnets[i].id
  addressPrefix: VirtualNetworkName_resource.properties.subnets[i].properties.addressPrefix
}]
output Tier0SubnetPrefix string = VirtualNetworkName_resource.properties.subnets[2].properties.addressPrefix
