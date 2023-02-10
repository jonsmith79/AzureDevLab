
param location string
param nsgName string
param tags object

var SourceAddress = 'VirtualNetwork'
var SourcePortRange = '*'
var DestinationPortRanges = '49152-65535'
var DestinationAddress = 'VirtualNetwork'

resource newNSG 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgName
  location: location
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddress
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
          sourcePortRange: SourcePortRange
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
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
          destinationAddressPrefix: DestinationAddress
          destinationPortRange: SourcePortRange
        }
      }
    ]
  }
  tags: tags
}
