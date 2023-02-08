//param vnetName string
param subnetName string
param properties object

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${subnetName}'
  properties: properties
}
