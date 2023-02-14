/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/
@description('Location for all resources.')
param Location string

@maxLength(64)
@description('Assignment name')
param assignmentName string 

@description('Assignement description')
param assignmentDescription string

@description('Assignement enforcement mode')
param assignmentEnforcementMode string = 'Default'

@description('Policy definition or policy set ID')
param assignmentPolicyID string

@description('Assignment non-compliance messages')
param assignmentNonComplianceMessages array 

@description('Assignment Resource Selectors')
param resourceSelectors array

@description('Assignment Paramters')
param assignmentParameters object



/*-------------------------------------------------------------------------------------------
 Resource section
-------------------------------------------------------------------------------------------*/

resource policyAssignment_resource 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: assignmentName
  location: Location
  identity: {
    type: 'SystemAssigned'
    //userAssignedIdentities: {}
  }
  properties: {
    description: assignmentDescription
    displayName: assignmentName
    enforcementMode: assignmentEnforcementMode
    nonComplianceMessages: assignmentNonComplianceMessages
    parameters: (!empty(assignmentParameters)) ? assignmentParameters : {}
    policyDefinitionId: assignmentPolicyID
    resourceSelectors: resourceSelectors
  }
}

output identityID string = policyAssignment_resource.identity.principalId

resource roleAssignmentContributor_resource 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(policyAssignment_resource.id, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  properties: {
    //description: 'Contributor role assignment for policy assignment'
    principalId: policyAssignment_resource.identity.principalId
    roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
}

resource roleAssignmentResourcePolicyContributor_resource 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(policyAssignment_resource.id, '36243c78-bf99-498c-9df9-86d9f8d28608')
  properties: {
    //description: 'Resource Policy Contributor role assignment for policy assignment'
    principalId: policyAssignment_resource.identity.principalId
    roleDefinitionId: '36243c78-bf99-498c-9df9-86d9f8d28608'
  }
}
