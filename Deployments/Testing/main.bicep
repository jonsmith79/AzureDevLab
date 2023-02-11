targetScope = 'subscription'

param location string
param namingConvention string
param VNetID string
param timeStamp string = utcNow('yyyy-MM-dd-HH:mm')

var tags = {
  Environment: 'Dev'
  Owner: 'Jon Smith'
  DateCreated: timeStamp
}
var rgName = '${namingConvention}-RG'
var vnetName = '${namingConvention}-VNet'
/*var subnets = [
  'GatewaySubnet'
  'AzureBastionSubnet'
  '${vnetName}-Subnet-Tier0Infra'
  '${vnetName}-Subnet-Tier1Data'
  '${vnetName}-Subnet-Tier2Apps'
  '${vnetName}-Subnet-Tier3Web'
  '${vnetName}-Subnet-Tier4Client'
]*/

var subnets = [
  {
    name: 'GatewaySubnet'
    addressPrefix: '${VNetID}.0.0/24'
  }
  {
    name: 'AzureBastionSubnet'
    addressPrefix: '${VNetID}.1.0/24'
  }
  {
    name: '${vnetName}-Subnet-T0-Infra'
    addressPrefix: '${VNetID}.2.0/24'
  }
  {
    name: '${vnetName}-Subnet-T1-Data'
    addressPrefix: '${VNetID}.3.0/24'
  }
  {
    name: '${vnetName}-Subnet-T2-Apps'
    addressPrefix: '${VNetID}.4.0/24'
  }
  {
    name: '${vnetName}-Subnet-T3-Web'
    addressPrefix: '${VNetID}.5.0/24'
  }
  {
    name: '${vnetName}-Subnet-T4-Client'
    addressPrefix: '${VNetID}.6.0/24'
  }
]
//var nsgName = '${subnets[2].name}-NSG'
var nsgName = '${vnetName}-Subnet-T0-Infra-NSG'
//var nsgSubnet = subnets[2]

resource newRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
  tags: tags
}

module newVNet 'modules/vnet.bicep' = {
  name: 'newVNet-${vnetName}'
  scope: newRG
  params: {
    location: location
    vnetName: vnetName
    VNetID: VNetID
    subnets: subnets
    tags: tags
  }
}

module newNSG 'modules/nsg.bicep' = {
  name: 'newNSG'
  scope: newRG
  params: {
    location: location
    nsgName: nsgName
    tags: tags
  }
  dependsOn: [
    newVNet
  ]
}

