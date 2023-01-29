targetScope = 'resourceGroup'

@description('Azure Policy Assignment Name')
param AzPolName string

@description('Policy Definition ID of Initiative')
param AzPolDef string

resource AzPolAssign_resource 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: AzPolName
  properties: {
    policyDefinitionId: AzPolDef
    policyType: 'BuiltIn'
  }
}
