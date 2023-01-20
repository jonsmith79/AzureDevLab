@description('Virtual Network Name') 
param VirtualNetworkName string 

@description('Virtual Network Address Prefix') 
param VirtualNetworkAddressPrefix string

@description('Gateway Subnet Name')
param GatewaySubnetName string

@description('Gateway Subnet Address Prefix')
param GatewaySubnetAddressPrefix string 

@description('Subnet 1 Name')
param Subnet1Name string

@description('Subnet 1 Address Prefix')
param Subnet1AddressPrefix string

@description('Subnet 2 Name')
param Subnet2Name string

@description('Subnet 2 Address Prefix')
param Subnet2AddressPrefix string

@description('Subnet 3 Name')
param Subnet3Name string

@description('Subnet 3 Address Prefix')
param Subnet3AddressPrefix string

@description('Subnet 4 Name')
param Subnet4Name string

@description('Subnet 4 Address Prefix')
param Subnet4AddressPrefix string

@description('Subnet 5 Name')
param Subnet5Name string

@description('Subnet 5 Address Prefix')
param Subnet5AddressPrefix string

@description('Bastion Subnet Name')
param BastionSubnetName string

@description('Bastion Subnet Prefix')
param BastionSubnetPrefix string

@description('Resource Location')
param Location string

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
        name: Subnet3Name
        properties: {
          addressPrefix: Subnet3AddressPrefix
        }
      }
      {
        name: Subnet4Name
        properties: {
          addressPrefix: Subnet4AddressPrefix
        }
      }
      {
        name: Subnet5Name
        properties: {
          addressPrefix: Subnet5AddressPrefix
        }
      }
      {
        name: BastionSubnetName
        properties: {
          addressPrefix: BastionSubnetPrefix
        }
      }
    ]
  }
}

output VirtualNetworkName string = VirtualNetworkName
