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
var VNet1Subnets = [
  'GatewaySubnet'
  'AzureBastionSubnet'
  '${VNet1Name}-Subnet-T0-Infra'
  '${VNet1Name}-Subnet-T1-Data'
  '${VNet1Name}-Subnet-T2-Apps'
  '${VNet1Name}-Subnet-T3-Web'
  '${VNet1Name}-Subnet-T4-Client'
]
var VNet1SubnetArray = [for (subnet, i) in VNet1Subnets: {
  name: subnet
  prefix: '${VNet1ID}.${i}.0/24'
}]

// NSG Vaiables
var nsgNameADDS = '${VNet1Subnets[2]}-NSG'

// vmDC1 Variables
var vmDC1DataDisk1Name = 'NTDS'
var vmDC1Name = '${namingConvention}-DC01'
var vmDC1LastOctet = '4'
var vmDC1IP = '${VNet1ID}.2.${vmDC1LastOctet}'

// Policy Assignment variables for 'Deploy prerequisites to enable Guest Configuration policies on virtual machines'
var assignmentName = 'Deploy_VM_Prereqs'
var assignmentDescription = 'Assignment of the \'Deploy prerequisites to enable Guest Configuration policies on virtual machines\' initiative (policy set) to VMs'
var assignmentEnforcementMode = 'Default'
var assignmentPolicyID = '/providers/Microsoft.Authorization/policySetDefinitions/12794019-7a00-42cf-95c2-882eed337cc8'
var assignmentNonComplianceMessages = [
  {
    message: 'Non-compliance with \'Deploy_VM_Prereqs\''
    policyDefinitionReferenceId: ''
  }
  {
    message: 'Non-compliance with \'adding managed identity on VMs with no ID\''
    policyDefinitionReferenceId: 'Prerequisite_AddSystemIdentityWhenNone'
  }
  {
    message: 'Non-compliance with \'adding managed identity on VMs with user assigned ID\''
    policyDefinitionReferenceId: 'Prerequisite_AddSystemIdentityWhenUser'
  }
  {
    message: 'Non-compliance with \'depoying guest config extension on Windows VMs\''
    policyDefinitionReferenceId: 'Prerequisite_DeployExtensionWindows'
  }
  {
    message: 'Non-compliance with \'depoying guest config extension on Linux VMs\''
    policyDefinitionReferenceId: 'Prerequisite_DeployExtensionLinux'
  }
]
var resourceSelectors = [
  {
    name: 'VM Selector'
    selectors: [
      {
        in: [
          'Microsoft.Compute/virtualMachines'
        ]
        kind: 'resourceType'
      }
    ]
  }
]

// Policy Assignment variables for 'Configure virtual machines to be onboarded to Azure Automanage'
var AzPolAutomanageName = 'Onboard_VMs_to_Automanage'
var AzPolAutomanageDescription = 'Assignment of the \'Configure virtual machines to be onboarded to Azure Automanage\' policy to VMs'
var AzPolAutomanageEnforcementMode = 'Default'
var AzPolAutomanagePolicyID = '/providers/Microsoft.Authorization/policyDefinitions/f889cab7-da27-4c41-a3b0-de1f6f87c550'
var AzPolAutomanageNonComplianceMessages = [
  {
    message: 'Non-compliance with \'Configure virtual machines to be onboarded to Azure Automanage\''
    policyDefinitionReferenceId: ''
  }
]
var AzPolAutomanageResourceSelectors = [
  {
    name: 'VM Selector'
    selectors: [
      {
        in: [
          'Microsoft.Compute/virtualMachines'
        ]
        kind: 'resourceType'
      }
    ]
  }
]

/*
// vmDC1 extension variables
var vmExtensionName = 'AzurePolicyforWindows'
var vmExtensionPublisher = 'Microsoft.GuestConfiguration'
var vmExtensionType = 'ConfigurationforWindows'
var vmExtensionTypeHandlerVersion = '1.1'
var vmExtensionAutoUpgrade = true
var vmExtensionAutoUpgradeMinorVersion = true
*/



// =================
// Resources Section
// =================

// Deploy new resource group if it doesn't already exist
@description('Create new resource group')
resource newRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: ResourceGroupName
  location: Location
}
output RGID string = newRG.id

// Deploy ADDS NSG
@description('Deploy ADDS NSG onto Tier0Infra Subnet')
module nsgADDS_resource 'modules/vnetNSGADDS.bicep' = {
  name: 'deploy-${nsgNameADDS}'
  scope: newRG
  params: {
    nsgNameADDS: nsgNameADDS
    Location: Location
    DestinationAddressPrefix: VNet1SubnetArray[2].prefix
  }
}

// Deploy Virtual Network 1 (VNet1)
@description('Deploy VNet1 to new resource group')
module VNet1 'modules/vnet.bicep' = {
  name: 'deploy-${VNet1Name}'
  scope: newRG
  params: {
    VirtualNetworkName: VNet1Name
    VirtualNetworkAddressPrefix: VNet1ID
    Subnets: VNet1SubnetArray
    nsgID: nsgADDS_resource.outputs.nsgID
    Location: Location
  }
  dependsOn: [
    nsgADDS_resource
  ]
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
    SubnetName: VNet1Subnets[1]
    Location: Location
  }
  dependsOn: [
    VNet1
  ]
}

// Assign the 'Deploy prerequisites to enable Guest Configuration policies on virtual machines' policy initiative to the resource group
@description('Assign the \'Deploy prerequisites to enable Guest Configuration policies on virtual machines\' policy initiative to the resource group')
module AzPolAssign 'modules/policyAssignment.bicep' = {
  name: assignmentName
  scope: subscription()
  params: {
    Location: Location
    assignmentName: assignmentName
    assignmentDescription: assignmentDescription
    assignmentEnforcementMode: assignmentEnforcementMode
    assignmentPolicyID: assignmentPolicyID
    assignmentNonComplianceMessages: assignmentNonComplianceMessages
    resourceSelectors: resourceSelectors
  }
}

// Assign the 'Configure virtual machines to be onboarded to Azure Automanage' policy to the resource group
@description('Assign the \'Configure virtual machines to be onboarded to Azure Automanage\' policy to the resource group')
module AzPolAutomanageAssign 'modules/policyAssignment.bicep' = {
  name: AzPolAutomanageName
  scope: subscription()
  params: {
    Location: Location
    assignmentName: AzPolAutomanageName
    assignmentDescription: AzPolAutomanageDescription
    assignmentEnforcementMode: AzPolAutomanageEnforcementMode
    assignmentPolicyID: AzPolAutomanagePolicyID
    assignmentNonComplianceMessages: AzPolAutomanageNonComplianceMessages
    resourceSelectors: AzPolAutomanageResourceSelectors
  }
  dependsOn: [
    AzPolAssign
  ]
}

// Deploy first domain controller
@description('Deploy first domain controller to VNet1')
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
    SubnetName: VNet1Subnets[2]
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
    AzPolAssign
  ]
}

/*
// Add extension to first domain controller
@description('Add extension to first domain controller')
module vmDC1Extension_add 'modules/vmExtension.bicep' = {
  scope: newRG
  name: vmExtensionName
  params: {
    vmExtensionName: vmExtensionName
    vmExtensionPublisher: vmExtensionPublisher
    vmExtensionType: vmExtensionType
    vmExtensionTypeHandlerVersion: vmExtensionTypeHandlerVersion
    vmExtensionAutoUpgrade: vmExtensionAutoUpgrade
    vmExtensionAutoUpgradeMinorVersion: vmExtensionAutoUpgradeMinorVersion
    vmName: vmDC1Name
    Location: Location
    //vmResourceGroup: ResourceGroupName
  }
  dependsOn: [
    vmDC1_deploy
  ]
}
*/

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