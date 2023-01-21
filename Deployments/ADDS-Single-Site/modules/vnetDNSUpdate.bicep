@description('VNet name')
param VNetName string

@description('VNet prefix')
param VNetPrefix string

@description('Gateway Subnet Name')
param GatewaySubnetName string

@description('Gateway Subnet Prefix')
param GatewaySubnetPrefix string

@description('Subnet 1 Name')
param Subnet1Name string

@description('Subnet 1 Prefix')
param Subnet1Prefix string

@description('Subnet 2 Name')
param Subnet2Name string

@description('Subnet 2 Prefix')
param Subnet2Prefix string

@description('Subnet 3 Name')
param Subnet3Name string

@description('Subnet 3 Prefix')
param Subnet3Prefix string

@description('Subnet 4 Name')
param Subnet4Name string

@description('Subnet 4 Prefix')
param Subnet4Prefix string

@description('Subnet 5 Name')
param Subnet5Name string

@description('Subnet 5 Prefix')
param Subnet5Prefix string

@description('Bastion Subnet Name')
param BastionSubnetName string

@description('Bastion Subnet Prefix')
param BastionSubnetPrefix string

@description('The DNS address(es) of the DNS Server(s) used by the VNET')
param DNSServerIP array

@description('Region of Resources')
param Location string

resource VNetName_resource 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: VNetName
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        VNetPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: DNSServerIP
    }
    subnets: [
      {
        name: GatewaySubnetName
        properties: {
          addressPrefix: GatewaySubnetPrefix
        }
      }
      {
        name: Subnet1Name
        properties: {
          addressPrefix: Subnet1Prefix
        }
      }
      {
        name: Subnet2Name
        properties: {
          addressPrefix: Subnet2Prefix
        }
      }
      {
        name: Subnet3Name
        properties: {
          addressPrefix: Subnet3Prefix
        }
      }
      {
        name: Subnet4Name
        properties: {
          addressPrefix: Subnet4Prefix
        }
      }
      {
        name: Subnet5Name
        properties: {
          addressPrefix: Subnet5Prefix
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

output VNetName string = VNetName
