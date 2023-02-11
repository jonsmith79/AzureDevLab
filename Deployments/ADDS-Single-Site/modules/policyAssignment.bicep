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
    parameters: {}
    policyDefinitionId: assignmentPolicyID
    resourceSelectors: resourceSelectors
  }
}
