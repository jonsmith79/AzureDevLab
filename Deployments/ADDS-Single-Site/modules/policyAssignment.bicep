targetScope = 'subscription'

@description('Azure Policy Assignment Name')
param AzPolName string

@description('Policy Definition ID of Initiative')
param AzPolDef string

resource AzPolAssign_resource 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: AzPolName // Should be unique within your target scope
  scope: subscriptionResourceId('Microsoft.Resources/resourceGroups', resourceGroup().name)
  properties: {
    policyDefinitionId: AzPolDef // Reference a policy specified in the same Bicep file
    enforcementMode: 'Default'
    displayName: 'Assign ${AzPolName}'
  }
}
