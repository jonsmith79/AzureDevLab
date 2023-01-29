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

@description('TimeZone for Virtual Machines')
param TimeZone string

@description('Enable Auto Shutdown')
param AutoShutdownEnabled string

@description('Auto Shutdown Time')
param AutoShutdownTime string

@description('Auto Shutdown Email')
param AutoShutdownEmail string

@description('The name of the Administrator of the new VM and Domain')
param adminUsername string

@description('The password for the Administrator account of the new VM and Domain')
@secure()
param adminPassword string

@description('Windows Server OS License Type')
param WindowsServerLicenseType string

@description('Domain Controller1 OS Version')
param vmDC1OSVersion string

@description('Domain Controller1 VMSize')
param vmDC1VMSize string



// =================
// Variables Section
// =================

// Resource Group Variables
var ResourceGroupName = '${namingConvention}-RG'

// VNet1 Variables
var VNet1Name = '${namingConvention}-VNet1'
var VNet1Prefix = '${VNet1ID}.0.0/16'
var VNet1GatewaySubnetName = 'GatewaySubnet'
var VNet1GatewaySubnetPrefix = '${VNet1ID}.0.0/24'
var VNet1Subnet1Name = '${namingConvention}-VNet1-Subnet-Tier0Infra'
var VNet1Subnet1Prefix = '${VNet1ID}.1.0/24'
var VNet1Subnet2Name = '${namingConvention}-VNet1-Subnet-Tier1Data'
var VNet1Subnet2Prefix = '${VNet1ID}.2.0/24'
var VNet1Subnet3Name = '${namingConvention}-VNet1-Subnet-Tier2Apps'
var VNet1Subnet3Prefix = '${VNet1ID}.3.0/24'
var VNet1Subnet4Name = '${namingConvention}-VNet1-Subnet-Tier3Web'
var VNet1Subnet4Prefix = '${VNet1ID}.4.0/24'
var VNet1Subnet5Name = '${namingConvention}-VNet1-Subnet-Tier4Client'
var VNet1Subnet5Prefix = '${VNet1ID}.10.0/24'
var VNet1BastionSubnetPrefix = '${VNet1ID}.253.0/24'
var VNet1BastionSubnetName = 'AzureBastionSubnet'
var nsgNameADDS = '${VNet1Subnet1Name}-NSG'

// vmDC1 Variables
var vmDC1DataDisk1Name = 'NTDS'
var vmDC1Name = '${namingConvention}-DC01'
var vmDC1LastOctet = '4'
var vmDC1IP = '${VNet1ID}.1.${vmDC1LastOctet}'

// Policy Assignment variables
var AzPolName = 'Deploy prerequisites to enable Guest Configuration policies on virtual machines'
var AzPolDef = '/providers/Microsoft.Authorization/policySetDefinitions/12794019-7a00-42cf-95c2-882eed337cc8'


// =================
// Resources Section
// =================

// Deploy new resource group
@description('Create new resource group')
resource newRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: ResourceGroupName
  location: Location
}
output RGID string = newRG.id

// Deploy Virtual Network 1 (VNet1)
@description('Deploy VNet1 to new resource group')
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
    nsgNameADDS: nsgNameADDS
  }
}

// Deploy Bastion Host 1 (BastionHost1)
@description('Deploy Bastion Host to VNet1')
module BastionHost1 'modules/bastionhost.bicep' = {
  name: 'BastionHost1'
  scope: newRG
  params: {
    PIPAddressName: '${namingConvention}-PIP-BastionHost1'
    PIPAllocationMethod: 'Static'
    BastionVNetName: VNet1Name
    SubnetName: VNet1BastionSubnetName
    Location: Location
  }
  dependsOn: [
    VNet1
  ]
}

@description('Assign Policy Initiative to the Resource Group')
module AzPolAssign 'modules/policyAssignment.bicep' = {
  name: 'Assign-to-${ResourceGroupName}'
  scope: newRG
  params: {
    AzPolName: AzPolName
    AzPolDef: AzPolDef
  }
}


// Deploy first domain controller
module vmDC1_deploy 'modules/vmDCs.bicep' = {
  scope: newRG
  name: 'Deploy-vmDC1'
  params: {
    AutoShutdownEmail: AutoShutdownEmail
    AutoShutdownEnabled: AutoShutdownEnabled
    AutoShutdownTime: AutoShutdownTime
    DataDisk1Name: vmDC1DataDisk1Name
    LicenceType: WindowsServerLicenseType
    Location: Location
    Offer: 'WindowsServer'
    OSVersion: vmDC1OSVersion
    Publisher: 'MicrosoftWindowsServer'
    SubnetName: VNet1Subnet1Name
    TimeZone: TimeZone
    vmAdminPwd: adminPassword
    vmAdminUser: adminUsername
    vmName: vmDC1Name
    vmNICIP: vmDC1IP
    vmSize: vmDC1VMSize
    VNetName: VNet1Name
  }
  dependsOn: [
    BastionHost1
  ]
}



/*
// Update DNS servers on subnets
module VNet1DNSUpdate 'modules/vnetDNSUpdate.bicep' = {
  scope: newRG
  name: 'VNet1DNSUpdate'
  params: {
    BastionSubnetName: VNet1BastionSubnetName
    BastionSubnetPrefix: VNet1BastionSubnetPrefix
    DNSServerIP: [
      vmDC1IP
    ]
    GatewaySubnetName: VNet1GatewaySubnetName
    GatewaySubnetPrefix: VNet1GatewaySubnetPrefix
    Location: Location
    Subnet1Name: VNet1Subnet1Name
    Subnet1Prefix: VNet1Subnet1Prefix
    Subnet2Name: VNet1Subnet2Name
    Subnet2Prefix: VNet1Subnet2Prefix
    Subnet3Name: VNet1Subnet3Name
    Subnet3Prefix: VNet1Subnet3Prefix
    Subnet4Name: VNet1Subnet4Name
    Subnet4Prefix: VNet1Subnet4Prefix
    Subnet5Name: VNet1Subnet5Name
    Subnet5Prefix: VNet1Subnet5Prefix
    VNetName: VNet1Name
    VNetPrefix: VNet1Prefix
  }
  dependsOn: [
    vmDC1_deploy
  ]
}
*/
