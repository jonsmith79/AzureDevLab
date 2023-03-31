/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/

@description('VNet name')
param VNetName string

@description('VNet prefix')
param VNetPrefix string

@description('NSG ID')
param nsgID string

@description('The DNS address(es) of the DNS Server(s) used by the VNET')
param DNSServerIPs array

@description('Region of Resources')
param Location string

@description('Virtual Network Subnets')
param Subnets array

/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/

var VNetIPRange = '${VNetPrefix}.0.0/16'

/*-------------------------------------------------------------------------------------------
  Resources section
-------------------------------------------------------------------------------------------*/

// Create the Virtual Network (VNet) and all associated subnets
resource updateVNet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: VNetName
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        VNetIPRange
      ]
    }
    dhcpOptions: {
      dnsServers: DNSServerIPs
    }
    subnets: [for (subnet, i) in Subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.prefix
        networkSecurityGroup: (subnet.name == Subnets[2].name) ? {
          id: nsgID
        } : null
      } 
    }]
  }
}

/*-------------------------------------------------------------------------------------------
  Outputs section
-------------------------------------------------------------------------------------------*/
output VNetID string = updateVNet.id
