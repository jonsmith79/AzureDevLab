/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/

@description('VNet name')
param VNetName string

@description('The DNS address(es) of the DNS Server(s) used by the VNET')
param DNSServerIPs array

@description('Region of Resources')
param Location string

@description('The properties of the existing VNet (from getVNet)')
param Properties object

/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/


/*-------------------------------------------------------------------------------------------
  Resources section
-------------------------------------------------------------------------------------------*/

// Update the Virtual Network (VNet) and all associated DNS entries
resource updateVNet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: VNetName
  location: Location
  properties: union(Properties, { 
    dhcpOptions: {
      dnsServers: DNSServerIPs
    }
  })    
}

/*-------------------------------------------------------------------------------------------
  Outputs section
-------------------------------------------------------------------------------------------*/
output updateVNetID string = updateVNet.id
