targetScope = 'subscription'

/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/
@description('Required. The name of the policy assignment ID.')
param policyID string

@description('Required. The name of the policy assignment identity ID.')
param identityID string


/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/




/*-------------------------------------------------------------------------------------------
  Resources section
-------------------------------------------------------------------------------------------*/
// Contributor role assignment for policy assignment ID
resource roleAssignmentContributor_resource 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(policyID, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  scope: subscription()
  properties: {
    description: 'Contributor role assignment for policy assignment ID'
    principalId: identityID
    roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
}

// Resource Policy Contributor role assignment for policy assignment ID
resource roleAssignmentResourcePolicyContributor_resource 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(policyID, '36243c78-bf99-498c-9df9-86d9f8d28608')
  scope: subscription()
  properties: {
    description: 'Resource Policy Contributor role assignment for policy assignment'
    principalId: identityID
    roleDefinitionId: '36243c78-bf99-498c-9df9-86d9f8d28608'
  }
}


/*-------------------------------------------------------------------------------------------
  Outputs section
-------------------------------------------------------------------------------------------*/

