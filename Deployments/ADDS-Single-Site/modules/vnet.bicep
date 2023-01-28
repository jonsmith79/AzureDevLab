//===================
// Parameters section
//===================
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

@description('NSG Name')
param nsgNameADDS string

//==================
// Variables section
//==================
var SourceAddresses = [
  GatewaySubnetAddressPrefix
  Subnet1AddressPrefix
  Subnet2AddressPrefix
  Subnet3AddressPrefix
  Subnet4AddressPrefix
  Subnet5AddressPrefix
  BastionSubnetPrefix
]

var SourcePortRanges = [
  '49152-65535'
]
var DestinationPortRanges = '49152-65535'
var DNSSourcePortRanges = [
  '53'
  DestinationPortRanges
]


//==================
// Resrouces section
//==================

// Create NSG for ADDS infrastructure subnet
resource nsgADDS_resource 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgNameADDS
  location: Location
  properties: {
    securityRules: [
      {
        name: 'W32Time'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Udp'
          priority: 301
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '123'
        }
      }
      {
        name: 'RPC Endpoint Mappper'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 302
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '135'
        }
      }
      {
        name: 'Kerberos password change (TCP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 303
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '464'
        }
      }
      {
        name: 'Kerberos password change (UDP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Udp'
          priority: 304
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '464'
        }
      }
      {
        name: 'RPC for LSA, SAM, NetLogon'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 305
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: DestinationPortRanges
        }
      }
      {
        name: 'LDAP (TCP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 306
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '389'
        }
      }
      {
        name: 'LDAP (UDP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Udp'
          priority: 307
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '389'
        }
      }
      {
        name: 'LDAP SSL'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 308
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '636'
        }
      }
      {
        name: 'LDAP GC'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 309
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '3268'
        }
      }
      {
        name: 'LDAP GC SSL'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 310
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '3269'
        }
      }
      {
        name: 'DNS (TCP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 311
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: DNSSourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '53'
        }
      }
      {
        name: 'DNS (UDP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Udp'
          priority: 312
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: DNSSourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '53'
        }
      }
      {
        name: 'FRS RPC'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 313
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: DestinationPortRanges
        }
      }
      {
        name: 'Kerberos (TCP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 314
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '88'
        }
      }
      {
        name: 'Kerberos (UDP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Udp'
          priority: 315
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '88'
        }
      }
      {
        name: 'SMB'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 316
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: '445'
        }
      }
      {
        name: 'DFSR RCP'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 317
          sourceAddressPrefixes: SourceAddresses
          sourcePortRanges: SourcePortRanges
          destinationAddressPrefix: Subnet1AddressPrefix
          destinationPortRange: DestinationPortRanges
        }
      }
    ]
  }
}

// Create the Virtual Network (VNet) and all associated subnets
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
          networkSecurityGroup: {
            id: nsgADDS_resource.id
          }
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

//=================
// Output's section
//=================
output VirtualNetworkName string = VirtualNetworkName
