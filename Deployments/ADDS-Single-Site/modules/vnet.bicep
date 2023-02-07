//===================
// Parameters section
//===================
@description('Virtual Network Name') 
param VirtualNetworkName string 

@description('Virtual Network Address Prefix') 
param VirtualNetworkAddressPrefix string

/*
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
*/

@description('Virtual Network Subnets')
param Subnets array

@description('Resource Location')
param Location string

//@description('NSG Name')
//param nsgNameADDS string

//==================
// Variables section
//==================
/*
var SourceAddresses = [
  GatewaySubnetAddressPrefix
  Subnet1AddressPrefix
  Subnet2AddressPrefix
  Subnet3AddressPrefix
  Subnet4AddressPrefix
  Subnet5AddressPrefix
  BastionSubnetPrefix
]
*/
var VNetIPRange = '${VirtualNetworkAddressPrefix}.0.0/16'
//var SourceAddress = 'VirtualNetwork'
/*
var SourcePortRanges = [
  '49152-65535'
]
*/
/*
var SourcePortRange = '*'
var DestinationPortRanges = '49152-65535'
var DNSSourcePortRanges = [
  '53'
  DestinationPortRanges
]
var DestinationAddressPrefix = '10.0.1.0/24'
*/

//==================
// Resrouces section
//==================
/*
// Create NSG for ADDS infrastructure subnet
resource nsgADDS_resource 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgNameADDS
  location: Location
  properties: {
    securityRules: [
      {
        name: 'Inbound W32Time'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Udp'
          priority: 300
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '123'
        }
      }
      {
        name: 'Inbound RPC Endpoint Mappper'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 305
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '135'
        }
      }
      {
        name: 'Inbound Kerberos password change (TCP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 310
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '464'
        }
      }
      {
        name: 'Inbound Kerberos password change (UDP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Udp'
          priority: 315
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '464'
        }
      }
      {
        name: 'Inbound RPC for LSA, SAM, NetLogon'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 320
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: DestinationPortRanges
        }
      }
      {
        name: 'Inbound LDAP (TCP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 325
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '389'
        }
      }
      {
        name: 'Inbound LDAP (UDP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Udp'
          priority: 330
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '389'
        }
      }
      {
        name: 'Inbound LDAP SSL'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 335
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '636'
        }
      }
      {
        name: 'Inbound LDAP GC'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 340
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '3268'
        }
      }
      {
        name: 'Inbound LDAP GC SSL'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 345
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '3269'
        }
      }
      {
        name: 'Inbound DNS (TCP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 350
          sourceAddressPrefix: SourceAddress
          sourcePortRanges: DNSSourcePortRanges
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '53'
        }
      }
      {
        name: 'Inbound DNS (UDP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Udp'
          priority: 355
          sourceAddressPrefix: SourceAddress
          sourcePortRanges: DNSSourcePortRanges
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '53'
        }
      }
      {
        name: 'Inbound FRS RPC'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 360
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: DestinationPortRanges
        }
      }
      {
        name: 'Inbound Kerberos (TCP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 365
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '88'
        }
      }
      {
        name: 'Inbound Kerberos (UDP)'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Udp'
          priority: 370
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '88'
        }
      }
      {
        name: 'Inbound SMB'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 375
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: '445'
        }
      }
      {
        name: 'Inbound DFSR RCP'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 380
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: DestinationPortRanges
        }
      }
      {
        name: 'Inbound ICMP'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Icmp'
          priority: 385
          sourceAddressPrefix: SourceAddress
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddressPrefix
          destinationPortRange: SourcePortRange
        }
      }
    ]
  }
}
*/

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
    /* subnets: [
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
    ] */
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
output VirtualNetworkName string = VirtualNetworkName
