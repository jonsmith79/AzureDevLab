targetScope = 'subscription'

param location string
param namingConvention string
param VNetID string
param timeStamp string = utcNow('yyyy-MM-dd-HH:mm')

var tags = {
  Environment: 'Test'
  Owner: 'Jon Smith'
  DateCreated: timeStamp
}
var rgName = '${namingConvention}-RG'
var vnetName = '${namingConvention}-VNet'
var subnets = [
  'GatewaySubnet'
  'AzureBastionSubnet'
  '${vnetName}-Subnet-T0-Infra'
  '${vnetName}-Subnet-T1-Data'
  '${vnetName}-Subnet-T2-Apps'
  '${vnetName}-Subnet-T3-Web'
  '${vnetName}-Subnet-T4-Client'
]
var subnetArray = [for (subnet, index) in subnets: {
  name: subnet
  prefix: '${VNetID}.${index}.0/24'
}]


//var nsgName = '${subnets[2].name}-NSG'
var nsgName = '${vnetName}-Subnet-T0-Infra-NSG'
//var nsgSubnet = subnets[2]

resource newRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
  tags: tags
}

module newNSG 'modules/nsg.bicep' = {
  name: 'newNSG'
  scope: newRG
  params: {
    location: location
    nsgName: nsgName
    tags: tags
  }
}

module newVNet 'modules/vnet.bicep' = {
  name: 'newVNet-${vnetName}'
  scope: newRG
  params: {
    location: location
    vnetName: vnetName
    VNetID: VNetID
    subnets: subnetArray
    nsgID: newNSG.outputs.nsgID
    tags: tags
  }
  dependsOn: [
    newNSG
  ]
}

/*
module attachNSG 'modules/nsgAttach.bicep' = {
  name: 'attachNSG'
  scope: newRG
  params: {
    VNet: vnetName
    nsg: nsgName
    subnet: subnets[2]
  }
  dependsOn: [
    newNSG
  ]
}
*/
