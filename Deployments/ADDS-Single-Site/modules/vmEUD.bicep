/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/
@description('End User Device (EUD) name')
param eudName string

@description('End User Device (EUD) location')
param eudLocation string = resourceGroup().location

@description('End User Device (EUD) timezone')
param eudTimezone string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${eudName}-${uniqueString(resourceGroup().id, eudName)}')

@description('Name for the Public IP used to access the Virtual Machine.')
param pipName string = '${eudName}-PIP'

@description('Allocation method for the Public IP used to access the Virtual Machine.')
@allowed([
  'Dynamic'
  'Static'
])
param pipAllocationMethod string = 'Dynamic'

@description('SKU for the Public IP used to access the Virtual Machine.')
@allowed([
  'Basic'
  'Standard'
])
param pipSku string = 'Basic'

@description('End User Device (EUD) Virtual Network Interface Card (vNIC) Subnet')
param eudSubnet string

@description('End User Device (EUD) License Type')
@allowed([
  'None'
  'Windows_Client'
  'Windows_Server'
])
param eudLicenseType string = 'Windows_Client'

@description('End User Device (EUD) Virtual Machine (VM) Size')
param eudVMSize string

@description('End User Device (EUD) Virtual Machine (VM) Image Publisher')
param eudVMPublisher string

@description('End User Device (EUD) Virtual Machine (VM) Image Offer')
param eudVMOffer string

@description('End User Device (EUD) Virtual Machine (VM) Image SKU')
param eudVMSKU string

@description('End User Device (EUD) Admin Username')
param eudAdminUsername string

@description('End User Device (EUD) Admin Password')
@secure()
param eudAdminPassword string

@description('End User Device (EUD) Auto Shutdown Enabled')
param eudAutoShutdownEnabled string

@description('End User Device (EUD) Auto Shutdown Time')
param eudAutoShutdownTime string

@description('End User Device (EUD) Auto Shutdown Email')
param eudAutoShutdownEmail string
/*
@description('End USer Device (EUD) Timezone')
@allowed([
  'Europe/London'
  'US/Pacific'
])
param eudTZ string = 'Europe/London'
*/
@description('Security Type of the Virtual Machine.')
@allowed([
  'Standard'
  'TrustedLaunch'
])
param securityType string = 'TrustedLaunch'

@description('Custom Attestation Endpoint to attest to. By default, MAA and ASC endpoints are empty and Azure values are populated based on the location of the VM.')
@allowed([
  ''
  'https://sharedcus.cus.attest.azure.net/'
  'https://sharedcae.cae.attest.azure.net/'
  'https://sharedeus2.eus2.attest.azure.net/'
  'https://shareduks.uks.attest.azure.net/'
  'https://sharedcac.cac.attest.azure.net/'
  'https://sharedukw.ukw.attest.azure.net/'
  'https://sharedneu.neu.attest.azure.net/'
  'https://sharedeus.eus.attest.azure.net/'
  'https://sharedeau.eau.attest.azure.net/'
  'https://sharedncus.ncus.attest.azure.net/'
  'https://sharedwus.wus.attest.azure.net/'
  'https://sharedweu.weu.attest.azure.net/'
  'https://sharedscus.scus.attest.azure.net/'
  'https://sharedsasia.sasia.attest.azure.net/'
  'https://sharedsau.sau.attest.azure.net/'
])
param maaEndpoint string = ''

/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/
var vNICName = '${eudName}-vNIC'
var securityProfileJson = {
  uefiSettings: {
    secureBootEnabled: true
    vTpmEnabled: true
  }
  securityType: securityType
}
var extensionName = 'GuestAttestation'
var extensionPublisher = 'Microsoft.Azure.Security.WindowsAttestation'
var extensionVersion = '1.0'
var maaTenantName = 'GuestAttestation'
var customScript = 'Set-WinSystemLocale en-GB\r\nSet-WinUserLanguageList -LanguageList en-GB -Force\r\nSet-Culture -CultureInfo en-GB\r\nSet-WinHomeLocation -GeoId 242\r\nRestart-Computer -Force'

/*-------------------------------------------------------------------------------------------
  Resources section
-------------------------------------------------------------------------------------------*/
resource PublicIP 'Microsoft.Network/publicIPAddresses@2022-09-01' = {
  name: pipName
  location: eudLocation
  sku: {
    name: pipSku
  }
  properties: {
    publicIPAllocationMethod: pipAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

resource vNIC 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: vNICName
  location: eudLocation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: eudSubnet
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: PublicIP.id
          }
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource eudVM 'Microsoft.Compute/virtualMachines@2022-11-01'= {
  name: eudName
  location: eudLocation
  properties: {
    licenseType: eudLicenseType
    hardwareProfile: {
      vmSize: eudVMSize
    }
    osProfile: {
      computerName: eudName
      adminUsername: eudAdminUsername
      adminPassword: eudAdminPassword
      customData: base64(customScript)
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        timeZone: eudTimezone
        additionalUnattendContent: [
          {
            passName: 'OobeSystem'
            componentName: 'Microsoft-Windows-Shell-Setup'
            settingName: 'FirstLogonCommands'
            content: '<FirstLogonCommands><SynchronousCommand><CommandLine>cmd /c "copy C:\\AzureData\\CustomData.bin C:\\Config.ps1"</CommandLine><Description>copy</Description><Order>1</Order></SynchronousCommand><SynchronousCommand><CommandLine>%windir%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -NoProfile -ExecutionPolicy Bypass -file C:\\Config.ps1</CommandLine><Description>script</Description><Order>2</Order></SynchronousCommand></FirstLogonCommands>'
          }
          {
            passName: 'OobeSystem'
            componentName: 'Microsoft-Windows-Shell-Setup'
            settingName: 'AutoLogon'
            content: '[concat(\'<AutoLogon><Password><Value>\',${eudAdminPassword},\'</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>\',${eudAdminUsername},\'</Username></AutoLogon>\')]'
          }
        ]
      }
    }
    storageProfile: {
      imageReference: {
        publisher: eudVMPublisher
        offer: eudVMOffer
        sku: eudVMSKU
        version: 'latest'
      }
      osDisk: {
        name: '${eudName}_OSDisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vNIC.id
        }
      ]
    }
    securityProfile: ((securityType == 'TrustedLaunch') ? securityProfileJson : null)
  }
}

resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = if ((securityType == 'TrustedLaunch') && (securityProfileJson.uefiSettings.secureBootEnabled == true && securityProfileJson.uefiSettings.vTpmEnabled == true)) {
  parent: eudVM
  name: extensionName
  location: eudLocation
  properties: {
    publisher: extensionPublisher
    type: extensionName
    typeHandlerVersion: extensionVersion
    autoUpgradeMinorVersion: true
    settings: {
      AttestationConfig: {
        MaaSettings: {
          maaEndpoint: maaEndpoint
          maaTenantName: maaTenantName
        }
      }
    }
  }
}

resource shutdown_computevm_computerName 'Microsoft.DevTestLab/schedules@2018-09-15' = if (eudAutoShutdownEnabled == 'Yes'){
  name: 'shutdown-computevm-${eudName}'
  location: eudLocation
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    timeZoneId: eudTimezone
    dailyRecurrence: {
      time: eudAutoShutdownTime
    }
    notificationSettings: {
      status: 'Enabled'
      timeInMinutes: 15
      emailRecipient: eudAutoShutdownEmail
      notificationLocale: 'en'
    }
    targetResourceId: eudVM.id
  }
}
/*-------------------------------------------------------------------------------------------
  Outputs section
-------------------------------------------------------------------------------------------*/
output hostname string = PublicIP.properties.dnsSettings.fqdn
