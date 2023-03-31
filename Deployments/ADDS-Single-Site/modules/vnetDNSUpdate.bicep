/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/

@description('VNet name')
param VNetName string

@description('The DNS address(es) of the DNS Server(s) used by the VNET')
param DNSServerIPs array

@description('Region of Resources')
param Location string

/*
@description('VNet prefix')
param VNetPrefix string

@description('Virtual Network Subnets')
param Subnets array

@description('NSG ID')
param nsgID string
*/

/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/

// var VNetIPRange = '${VNetPrefix}.0.0/16'

/*-------------------------------------------------------------------------------------------
  Resources section
-------------------------------------------------------------------------------------------*/

// Get existing VNet
resource getVNet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: VNetName
}

// Update the Virtual Network (VNet) and all associated DNS entries
resource updateVNet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: getVNet.name
  location: Location
  properties: union(getVNet.properties, { 
    dhcpOptions: {
      dnsServers: DNSServerIPs
    }
  })    
}

/*-------------------------------------------------------------------------------------------
  Outputs section
-------------------------------------------------------------------------------------------*/
output updateVNetID string = updateVNet.id
