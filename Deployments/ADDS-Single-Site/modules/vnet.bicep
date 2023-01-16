@description('Virtual Network Name') 
param VirtualNetworkName string 

@description('Virtual Network Address Prefix') 
param VirtualNetworkAddressPrefix string

@description('Subnet 1 Name')
param Subnet1Name string = 'GatewaySubnet'

@description('Subnet 1 Address Prefix')
param Subnet1AddressPrefix string 

@description('Subnet 2 Name')
param Subnet2Name string = 'ServerSubnet'

@description('Subnet 2 Address Prefix')
param Subnet2AddressPrefix string

@description('Subnet 3 Name')
param Subnet3Name string = 'ClientSubnet'

@description('Subnet 3 Address Prefix')
param Subnet3AddressPrefix string

@description('Bastion Subnet Prefix')
param BastionSubnetPrefix string

@description('Resource Location')
param Location string = resourceGroup().location

resource VirtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: VirtualNetworkName
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        VirtualNetworkAddressPrefix
      ]
    }
    subnets: [
      {
        name: Subnet1Name
        properties: {
          addressPrefix: Subnet1AddressPrefix
        }
      }
      {
        name: Subnet2Name
        properties: {
          addressPrefix: Subnet2AddressPrefix
        }
      }
      {
        name: Subnet3Name
        properties: {
          addressPrefix: Subnet3AddressPrefix
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: BastionSubnetPrefix
        }
      }
    ]
  }
}

output VirtualNetworkName string = VirtualNetworkName
