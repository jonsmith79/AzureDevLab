/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/
@description('Virtual Machine Name')
param vmName string

@description('Virtual Machine Network Interface 1 IP Address')
param vmNICIP string

@description('TimeZone')
param TimeZone string

@description('Enable or Disable Auto Shutdown')
param AutoShutdownEnabled string

@description('Time to Auto Shutdown VM')
param AutoShutdownTime string

@description('Autoshutdown Notification Email')
param AutoShutdownEmail string

@description('Image Publisher')
param Publisher string

@description('Image Publisher Offer')
param Offer string

@description('OS Version')
param OSVersion string

@allowed([
  'Windows_Server'
  'Windows_Client'
  'RHEL_BYOS'
  'SLES_BYOS'
  'None'
])
@description('Licence Type (Windows_Server or None)')
param LicenceType string

@description('Virtual Machine Size')
param vmSize string

@description('Existing VNet name that contains the domain controllers')
param VNetName string

@description('Existing Subnet name that containd the domain controllers')
param SubnetName string

@description('The name of the Administrator of the new VM and Domain')
param vmAdminUser string

@description('The password of the Adminstrator account of the new VM and Domain')
@secure()
param vmAdminPwd string

@description('Region of the Resources')
param Location string

/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/

var saType = 'Standard_LRS'
var SubnetID = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks/subnets', VNetName, SubnetName)
var vmID = resourceId(resourceGroup().name, 'Microsoft.Compute/virtualMachines', vmName)
var vmNICName = '${vmName}-NIC1'
var vmShutdownName = 'Shutdown-ComputeVM-${vmName}'

/*-------------------------------------------------------------------------------------------
  Resources section
-------------------------------------------------------------------------------------------*/

resource vmNICName_resource 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: vmNICName
  location: Location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          privateIPAddress: vmNICIP
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: SubnetID
          }
        }
      }
    ]
  }
}

resource vmName_resource 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: vmName
  location: Location
  properties: {
    licenseType: LicenceType
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: vmAdminUser
      adminPassword: vmAdminPwd
      allowExtensionOperations: true
      windowsConfiguration: LicenceType == 'Windows_Server' ? {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        timeZone: TimeZone
      } : null
    }
    storageProfile: {
      imageReference: {
        publisher: Publisher
        offer: Offer
        sku: OSVersion
        version: 'Latest'
      }
      osDisk: {
        name: '${vmName}_OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: saType
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vmNICName_resource.id
        }
      ]
    }
  }
}

resource vmShutdown_resource 'Microsoft.DevTestLab/schedules@2018-09-15' = if (AutoShutdownEnabled == 'Yes') {
  name: vmShutdownName
  location: Location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: AutoShutdownTime
    }
    timeZoneId: TimeZone
    notificationSettings: {
      status: 'Enabled'
      timeInMinutes: 30
      emailRecipient: AutoShutdownEmail
      notificationLocale: 'en'
    }
    targetResourceId: vmID
  }
  dependsOn: [
    vmName_resource
  ]
}

/*-------------------------------------------------------------------------------------------
  Outputs section
-------------------------------------------------------------------------------------------*/

// Output the VM IP Address
output vmIP string = vmNICName_resource.properties.ipConfigurations[0].properties.privateIPAddress
