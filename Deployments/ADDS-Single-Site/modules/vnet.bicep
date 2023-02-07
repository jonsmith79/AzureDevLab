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

@description('NSG Name')
param nsgNameADDS string

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
var SourceAddress = 'VirtualNetwork'
/*
var SourcePortRanges = [
  '49152-65535'
]
*/

var SourcePortRange = '*'
var DestinationPortRanges = '49152-65535'
var DNSSourcePortRanges = [
  '53'
  DestinationPortRanges
]
var DestinationAddressPrefix = '10.0.2.0/24'


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
        name: 'Inbound_W32Time'
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
        name: 'Inbound_RPC_Endpoint_Mappper'
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
        name: 'Inbound_Kerberos_password_change_TCP'
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
        name: 'Inbound_Kerberos_password_change_UDP'
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
        name: 'Inbound_RPC_for_LSA_SAM_NetLogon'
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
        name: 'Inbound_LDAP_TCP'
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
        name: 'Inbound_LDAP_UDP'
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
        name: 'Inbound_LDAP_SSL'
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
        name: 'Inbound_LDAP_GC'
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
        name: 'Inbound_LDAP_GC_SSL'
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
        name: 'Inbound_DNS_TCP'
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
        name: 'Inbound_DNS_UDP'
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
        name: 'Inbound_FRS_RPC'
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
        name: 'Inbound_Kerberos_TCP'
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
        name: 'Inbound_Kerberos_UDP'
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
        name: 'Inbound_SMB'
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
        name: 'Inbound_DFSR_RCP'
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
        name: 'Inbound_ICMP'
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
        networkSecurityGroup: {
          id: (SubnetName == 'adl-VNet1-Subnet-Tier0Infra') ? nsgADDS_resource.id : null
        }
      }
    }]
  }
}

//=================
// Output's section
//=================
// output VirtualNetworkName string = VirtualNetworkName
