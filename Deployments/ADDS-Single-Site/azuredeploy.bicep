// Set target scope
targetScope='subscription'


// ===================
// Paramaeters Section
// ===================

@description('Environment Naming Convention')
param namingConvention string

@description('Location 1 for Resources')
param Location string

@description('Virtual Network 1 Prefix')
param VNet1ID string


// =================
// Variables Section
// =================

// Resource Group Variables
var ResourceGroupName = '${namingConvention}-RG'

//VNet1 Variables
var VNet1Name = '${namingConvention}-VNet1'
var VNet1Prefix = '${VNet1ID}.0.0/16'
var VNet1GatewaySubnetName = 'GatewaySubnet'
var VNet1GatewaySubnetPrefix = '${VNet1ID}.0.0/24'
var VNet1Subnet1Name = '${namingConvention}-VNet1-InfrastructureTier'
var VNet1Subnet1Prefix = '${VNet1ID}.1.0/24'
var VNet1Subnet2Name = '${namingConvention}-VNet1-DataTier'
var VNet1Subnet2Prefix = '${VNet1ID}.2.0/24'
var VNet1Subnet3Name = '${namingConvention}-VNet1-ApplicationsTier'
var VNet1Subnet3Prefix = '${VNet1ID}.3.0/24'
var VNet1Subnet4Name = '${namingConvention}-VNet1-WebTier'
var VNet1Subnet4Prefix = '${VNet1ID}.4.0/24'
var VNet1Subnet5Name = '${namingConvention}-VNet1-ClientTier'
var VNet1Subnet5Prefix = '${VNet1ID}.10.0/24'
var VNet1BastionSubnetPrefix = '${VNet1ID}.253.0/24'
var VNet1BastionSubnetName = 'AzureBastionSubnet'


// =================
// Resources Section
// =================

// Deploy new resource group
resource newRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: ResourceGroupName
  location: Location
}

// Deploy Virtual Network 1 (VNet1)
module VNet1 'modules/vnet.bicep' = {
  name: 'VNet1'
  scope: newRG
  params: {
    VirtualNetworkName: VNet1Name
    VirtualNetworkAddressPrefix: VNet1Prefix
    GatewaySubnetName: VNet1GatewaySubnetName
    GatewaySubnetAddressPrefix: VNet1GatewaySubnetPrefix
    Subnet1Name: VNet1Subnet1Name
    Subnet1AddressPrefix: VNet1Subnet1Prefix
    Subnet2Name: VNet1Subnet2Name
    Subnet2AddressPrefix: VNet1Subnet2Prefix
    Subnet3Name: VNet1Subnet3Name
    Subnet3AddressPrefix: VNet1Subnet3Prefix
    Subnet4Name: VNet1Subnet4Name
    Subnet4AddressPrefix: VNet1Subnet4Prefix
    Subnet5Name: VNet1Subnet5Name
    Subnet5AddressPrefix: VNet1Subnet5Prefix
    BastionSubnetName: VNet1BastionSubnetName
    BastionSubnetPrefix: VNet1BastionSubnetPrefix
    Location: Location
  }
  dependsOn: [
    newRG
  ]
}

// Deploy Bastion Host 1 (BastionHost1)
module BastionHost1 'modules/bastionhost.bicep' = {
  name: 'BastionHost1'
  scope: newRG
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

