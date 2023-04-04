/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/

@description('VNet name')
param VNetName string

@description('The DNS address(es) of the DNS Server(s) used by the VNET')
param DNSServerIPs array

@description('Region of Resources')
param Location string

@description('The properties of the VNet')
param VNetProperties object


/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/


/*-------------------------------------------------------------------------------------------
  Resources section
-------------------------------------------------------------------------------------------*/

/*
// Get existing VNet
resource getVNet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: VNetName
}
*/

// Update the Virtual Network (VNet) and all associated DNS entries
resource updateVNet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: VNetName
  location: Location
  properties: union(VNetProperties, { 
    dhcpOptions: {
      dnsServers: DNSServerIPs
    }
  })    
}

/*-------------------------------------------------------------------------------------------
  Outputs section
-------------------------------------------------------------------------------------------*/
output updateVNetID string = updateVNet.id
