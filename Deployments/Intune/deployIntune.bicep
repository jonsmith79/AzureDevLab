// Set target scope
targetScope = 'subscription'

/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/
/*@description('Azure AD Admin Username')
param adminUsername string

@description('Azure AD Admin Password')
@secure()
param adminPassword string

@description('Artifacts location URL')
param artifactsLocation string

@description('artifacts SAS token')
param artifactsSasToken string*/

@description('Azure AD group prefix')
param azGroupPrefix string

@description('Azure AD Break Glass group name')
param azBreakGlassGroupName string

/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/
// Break Glass variables
var azBreakGlassGroup = '${azGroupPrefix}-${azBreakGlassGroupName}'

/*-------------------------------------------------------------------------------------------
  Resources section
-------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------------------
  Outputs section
-------------------------------------------------------------------------------------------*/
