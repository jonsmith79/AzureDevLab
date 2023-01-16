// Paramaeters Section
@description('Environment Naming Convention')
param namingConvention string = 'adl'

@description('Virtual Network 1 Prefix')
param VNet1ID string

// Variables Section
var VNet1Name = '${namingConvention}-VNet1'
var VNet1Prefix = '${VNet1ID}.0.0/16'
var VNet1GatewaySubnetPrefix = '${VNet1ID}.0.0/24'
var VNet1Subnet1Name = '${namingConvention}-VNet1-Servers'
var VNet1Subnet1Prefix = '${VNet1ID}.1.0/24'
var VNet1Subnet2Name = '${namingConvention}-VNet1-Clients'
var VNet1Subnet2Prefix = '${VNet1ID}.2.0/24'
var VNet1BastionSubnetPrefix = '${VNet1ID}.253.0/24'

// Deployments Section

// Deploy VNet1
module VNet1 'modules/vnet.bicep' = {
  name: 'VNet1'
  params: {
    VNet1Name: VirtualNetworkName
    VNet1Prefix: VirtualNetworkAddressPrefix
    VNet1GatewaySubnetPrefix: GatewaySubnetAddressPrefix
    VNet1Subnet1Name: Subnet1Name
    VNet1Subnet1Prefix: Subnet1AddressPrefix
    VNet1Subnet2Name: Subnet2Name
    VNet1Subnet2Prefix: Subnet2AddressPrefix
    VNet1BastionSubnetPrefix: BastionSubnetPrefix
  }
}
