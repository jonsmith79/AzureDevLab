//===================
// Parameters section
//===================

@description('Resource Location')
param Location string

@description('NSG Name')
param nsgNameClients string


//==================
// Variables section
//==================


//==================
// Resrouces section
//==================

// Create NSG for ADDS infrastructure subnet
resource newNSGClients 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgNameClients
  location: Location
  properties: {
    securityRules: [
      {
        name: 'Default_Allow_3389'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 1000
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
    ]
  }
}

//=================
// Output's section
//=================
output nsgClientsID string = newNSGClients.id
