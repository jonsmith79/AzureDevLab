@description('Virtual Network Name') 
param VirtualNetworkName string 

@description('Virtual Network Address Prefix') 
param VirtualNetworkAddressPrefix string

@description('Gateway Subnet Name')
param GatewaySubnetName string = 'GatewaySubnet'

@description('Gateway Subnet Address Prefix')
param GatewaySubnetAddressPrefix string 

@description('Subnet 1 Name')
param Subnet1Name string = 'ServerSubnet'

@description('Subnet 1 Address Prefix')
param Subnet1AddressPrefix string

@description('Subnet 2 Name')
param Subnet2Name string = 'ClientSubnet'

@description('Subnet 2 Address Prefix')
param Subnet2AddressPrefix string

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
        name: GatewaySubnetName
        properties: {
          addressPrefix: GatewaySubnetAddressPrefix
        }
      }
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
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: BastionSubnetPrefix
        }
      }
    ]
  }
}

output VirtualNetworkName string = VirtualNetworkName
