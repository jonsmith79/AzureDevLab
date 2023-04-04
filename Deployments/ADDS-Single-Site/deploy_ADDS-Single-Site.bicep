// Set target scope
targetScope='subscription'

/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/

@description('Environment Naming Convention')
param namingConvention string

@description('Location 1 for Resources')
param Location string

@description('Virtual Network 1 IP Octet 1')
param VNet1IPOctet1 int

@description('Virtual Network 1 IP Octet 2')
param VNet1IPOctet2 int

@description('TimeZone for Virtual Machines')
param TimeZone string
/*
@description('Enable Auto Shutdown')
param AutoShutdownEnabled string
*/
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

@description('NetBios Domain Name')
param NetBiosDomain string

@description('Sub DNS Domain Name')
param SubDNSDomain string

@description('Internal Domain Name')
param InternalDomainName string

@description('Internal DNS Top Level Domain Name')
param InternalTLD1 string

@description('Internal DNS Top Level Domain Name')
param InternalTLD2 string

@description('User Password for Domain Accounts')
@secure()
param userPassword string

@description('Artifacts Location')
param artifactsLocation string

@description('Artifacts Location Sas Token')
param artifactsLocationSasToken string

/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/

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
] // always have [2] slot in the array where ADDS should be installed
var VNet1IPPrefix = '${VNet1IPOctet1}.${VNet1IPOctet2}'
var VNet1IPPrefixReverse = '${VNet1IPOctet2}.${VNet1IPOctet1}'
var VNet1SubnetArray = [for (name, i) in VNet1Subnets: {
  name: name
  subnet: '${VNet1IPPrefix}.${i}.0/24'
  dnsForward: '${VNet1IPPrefix}.${i}'
  dnsReverse: '${i}.${VNet1IPPrefixReverse}'
}]

// NSG Vaiables
var nsgNameADDS = '${VNet1Subnets[2]}-NSG' // Make sure this is the array object where DC's will go

// Domain Variables
var ADDSDomainPrefix = (!empty(SubDNSDomain)) ? '${SubDNSDomain}.${InternalDomainName}' : InternalDomainName
var ADDSDomainTLD = (!empty(InternalTLD2)) ? '.${InternalTLD1}.${InternalTLD2}' : '.${InternalTLD1}'
var ADDSDomainName = '${ADDSDomainPrefix}${ADDSDomainTLD}'
var ADDSBaseDNPrefix = (!empty(SubDNSDomain)) ? 'DC=${SubDNSDomain},DC=${InternalDomainName}' : 'DC=${InternalDomainName}'
var ADDSBaseDNTLD = (!empty(InternalTLD2)) ? ',DC=${InternalTLD1},DC=${InternalTLD2}' : ',DC=${InternalTLD1}'
var ADDSBaseDN = '${ADDSBaseDNPrefix}${ADDSBaseDNTLD}'
var ForwardLookup1 = VNet1SubnetArray[2].dnsForward // Make sure this is the array object where DC's will go

// vmDC1 Variables
var vmDC1DataDisk1Name = 'NTDS'
var vmDC1Name = '${namingConvention}-DC01'
var vmDC1LastOctet = '4'
var vmDC1IP = '${ForwardLookup1}.${vmDC1LastOctet}'

/*
// vmDC2 Variables
var vmDC2DataDisk1Name = 'NTDS'
var vmDC2Name = '${namingConvention}-DC02'
var vmDC2LastOctet = '5'
var vmDC2IP = '${VNet1ID}.2.${vmDC2LastOctet}'
*/

// VNet1 DNS IPs
var VNet1DNSServers = [
  vmDC1IP
  //vmDC2IP
]

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
var assignmentParameters = {}

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
 var AzPolAutomanageParameters = {
  configurationProfileAssignment: {
    value: '/providers/Microsoft.Automanage/bestPractices/azurebestpracticesdevtest'
    }
  effect: {
    value: 'DeployIfNotExists'
  }
}





/*-------------------------------------------------------------------------------------------
  Resource section
-------------------------------------------------------------------------------------------*/

// Deploy new resource group if it doesn't already exist
@description('Create new resource group')
resource newRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: ResourceGroupName
  location: Location
}
output RGID string = newRG.id

// Assign the 'Deploy prerequisites to enable Guest Configuration policies on virtual machines' policy initiative to the resource group
@description('Assign the \'Deploy prerequisites to enable Guest Configuration policies on virtual machines\' policy initiative to the resource group')
module AzPolAssign 'modules/policyAssignment.bicep' = {
  name: 'assign_${assignmentName}'
  scope: newRG
  params: {
    Location: Location
    assignmentName: assignmentName
    assignmentDescription: assignmentDescription
    assignmentEnforcementMode: assignmentEnforcementMode
    assignmentPolicyID: assignmentPolicyID
    assignmentNonComplianceMessages: assignmentNonComplianceMessages
    resourceSelectors: resourceSelectors
    assignmentParameters: assignmentParameters
  }
}

// Assign the 'Configure virtual machines to be onboarded to Azure Automanage' policy to the resource group
@description('Assign the \'Configure virtual machines to be onboarded to Azure Automanage\' policy to the resource group')
module AzPolAutomanageAssign 'modules/policyAssignment.bicep' = {
  name: 'assign_${AzPolAutomanageName}'
  scope: newRG
  params: {
    Location: Location
    assignmentName: AzPolAutomanageName
    assignmentDescription: AzPolAutomanageDescription
    assignmentEnforcementMode: AzPolAutomanageEnforcementMode
    assignmentPolicyID: AzPolAutomanagePolicyID
    assignmentNonComplianceMessages: AzPolAutomanageNonComplianceMessages
    resourceSelectors: AzPolAutomanageResourceSelectors
    assignmentParameters: AzPolAutomanageParameters
  }
  dependsOn: [
    AzPolAssign
  ]
}

// Assign the 'Deploy prerequisites to enable Guest Configuration policies on virtual machines' policy system identity subscription roles
module AzPolAssign_permissions 'modules/roleAssignment.bicep' = {
  name: 'roleAssignment_${AzPolAssign.name}'
  scope: subscription()
  params: {
    policyID: AzPolAssign.outputs.policyID
    identityID: AzPolAssign.outputs.identityID
  }
}

// Assign the 'Configure virtual machines to be onboarded to Azure Automanage' policy system identity subscription roles
module AzPolAutomanageAssign_permissions 'modules/roleAssignment.bicep' = {
  name: 'roleAssignment_${AzPolAutomanageAssign.name}'
  scope: subscription()
  params: {
    policyID: AzPolAutomanageAssign.outputs.policyID
    identityID: AzPolAutomanageAssign.outputs.identityID
  }
}


// Deploy ADDS NSG
@description('Deploy ADDS NSG onto Tier0Infra Subnet')
module nsgADDS_resource 'modules/azVNetNSGADDS.bicep' = {
  name: 'deploy-${nsgNameADDS}'
  scope: newRG
  params: {
    nsgNameADDS: nsgNameADDS
    Location: Location
    DestinationAddressPrefix: VNet1SubnetArray[2].subnet
  }
  dependsOn: [
    //AzPolAutomanageAssign
    AzPolAssign
  ]
}

// Deploy Virtual Network 1 (VNet1)
@description('Deploy VNet1 to new resource group')
module VNet1 'modules/azVNet.bicep' = {
  name: 'deploy-${VNet1Name}'
  scope: newRG
  params: {
    VirtualNetworkName: VNet1Name
    VirtualNetworkAddressPrefix: VNet1IPPrefix
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
module BastionHost1 'modules/azBastion.bicep' = {
  name: 'deploy_BastionHost1'
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

// Deploy first domain controller
@description('Deploy first domain controller to VNet1')
module vmDC1_deploy 'modules/vmDCs.bicep' = {
  scope: newRG
  name: 'deploy_${vmDC1Name}'
  params: {
    AutoShutdownEmail: AutoShutdownEmail
    AutoShutdownEnabled: 'No'
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
  ]
}

//Promote first domain controller to domain controller
@description('Promote first domain controller to domain controller')
module promoteDC1 'modules/addsDC1.bicep' = {
  scope: newRG
  name: 'PromoteDC1'
  params: {
    computerName: vmDC1Name
    TimeZone: TimeZone
    NetBiosDomain: NetBiosDomain
    domainName: ADDSDomainName
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: Location          
    artifactsLocation:  artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    vmDC1_deploy
  ]
}

/*
// Deploy second domain controller
@description('Deploy second domain controller to VNet1')
module vmDC2_deploy 'modules/vmDCs.bicep' = {
  scope: newRG
  name: 'deploy_${vmDC2Name}'
  params: {
    AutoShutdownEmail: AutoShutdownEmail
    AutoShutdownEnabled: AutoShutdownEnabled
    AutoShutdownTime: AutoShutdownTime
    DataDisk1Name: vmDC2DataDisk1Name
    LicenceType: WindowsServerLicenseType
    Location: Location
    Offer: 'WindowsServer'
    OSVersion: vmDC1OSVersion
    Publisher: 'MicrosoftWindowsServer'
    SubnetName: VNet1Subnets[2]
    TimeZone: TimeZone
    vmAdminPwd: adminPassword
    vmAdminUser: adminUsername
    vmName: vmDC2Name
    vmNICIP: vmDC2IP
    vmSize: vmDC1VMSize
    VNetName: VNet1Name
  }
  dependsOn: [
    BastionHost1
  ]
}
*/

// Update vNet DNS Servers
@description('Update vNet DNS Servers')
module VNet1DNS 'modules/azVNetDNS.bicep' = {
  name: 'update-${VNet1Name}-DNS'
  scope: newRG
  params: {
    VNetName: VNet1Name
    Location: Location
    DNSServerIPs: VNet1DNSServers
    VNetProperties: VNet1.outputs.VNetObject.properties
  }
  dependsOn: [
    promoteDC1
    //promoteDC2
  ]
}

// Restart first domain controller
module vmDC1_restart 'modules/vmRestart.bicep' = {
  scope: newRG
  name: 'restart_${vmDC1Name}'
  params: {
    vmName: vmDC1Name
    Location: Location
    artifactsLocation:  artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    VNet1DNS
  ]
}

// Configure ADDS DNS settings
module DNS_config 'modules/addsDNS.bicep' = {
  scope: newRG
  name: 'configure_${vmDC1Name}_DNS'
  params: {
    vmName: vmDC1Name
    NetBiosDomain: NetBiosDomain
    InternalDomainName: ADDSDomainName
    ReverseLookup1: VNet1IPPrefixReverse
    ForwardLookup1: VNet1SubnetArray[2].dnsForward // Needs to be the subnet of the DC
    dc1lastoctet:vmDC1LastOctet
    adminUsername: adminUsername
    adminPassword: adminPassword
    Location: Location          
    artifactsLocation:  artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    vmDC1_restart
  ]
}

// Create ADDS Organisation Units
module CreateOUs 'modules/addsOUs.bicep' = {
  scope: newRG
  name: 'create_${vmDC1Name}_OUs'
  params: {
    computerName: vmDC1Name
    BaseDN: ADDSBaseDN
    Location: Location          
    artifactsLocation:  artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    DNS_config
  ]
}

// Create ADDS Users
module CreateUsers 'modules/addsUsers.bicep' = {
  scope: newRG
  name: 'create_${vmDC1Name}_Users'
  params: {
    vmName: vmDC1Name
    Location: Location
    ADDSBaseDN: ADDSBaseDN
    ADDSDomain: ADDSDomainName
    ADDSNetBiosDomain: NetBiosDomain
    ADDSUserPassword: userPassword          
    artifactsLocation:  artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    CreateOUs
  ]
}

