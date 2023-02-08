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
      properties: {
        addressPrefix: '${VirtualNetworkAddressPrefix}.${i}.0/24'
        /*networkSecurityGroup: {
          id: (SubnetName == 'adl-VNet1-Subnet-Tier0Infra') ? nsgADDS_resource.id : null
        }*/
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
}]
