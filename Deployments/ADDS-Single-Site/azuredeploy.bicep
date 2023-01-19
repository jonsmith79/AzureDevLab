// Paramaeters Section
@description('Environment Naming Convention')
param namingConvention string

@description('Location 1 for Resources')
param Location string

@description('Virtual Network 1 Prefix')
param VNet1ID string

// Variables Section

//VNet1 Variables
var VNet1Name = '${namingConvention}-VNet1'
var VNet1Prefix = '${VNet1ID}.0.0/16'
var VNet1GatewaySubnetPrefix = '${VNet1ID}.0.0/24'
var VNet1Subnet1Name = '${namingConvention}-VNet1-Servers'
var VNet1Subnet1Prefix = '${VNet1ID}.1.0/24'
var VNet1Subnet2Name = '${namingConvention}-VNet1-Clients'
var VNet1Subnet2Prefix = '${VNet1ID}.2.0/24'
var VNet1BastionSubnetPrefix = '${VNet1ID}.253.0/24'
var VNet1BastionSubnetName = 'AzureBastionSubnet'

// Resources Section

// Deploy VNet1
module VNet1 'modules/vnet.bicep' = {
  name: 'VNet1'
  params: {
    VirtualNetworkName: VNet1Name
    VirtualNetworkAddressPrefix: VNet1Prefix
    GatewaySubnetAddressPrefix: VNet1GatewaySubnetPrefix
    Subnet1Name: VNet1Subnet1Name
    Subnet1AddressPrefix: VNet1Subnet1Prefix
    Subnet2Name: VNet1Subnet2Name
    Subnet2AddressPrefix: VNet1Subnet2Prefix
    BastionSubnetName: VNet1BastionSubnetName
    BastionSubnetPrefix: VNet1BastionSubnetPrefix
    Location: Location
  }
}

module BastionHost1 'modules/bastionhost.bicep' = {
  name: 'BastionHost1'
  params: {
    PIPAddressName: '${namingConvention}PIP-BastionHost1'
    PIPAllocationMethod: 'Static'
    BastionVNetName: VNet1Name
    SubnetName: VNet1BastionSubnetName
    Location: Location
  }
  dependsOn: [
    VNet1
  ]
}

